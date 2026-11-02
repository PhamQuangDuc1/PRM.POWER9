import android.app.UiAutomation;
import android.os.HandlerThread;
import android.os.SystemClock;
import android.view.accessibility.AccessibilityNodeInfo;
import android.view.accessibility.AccessibilityEvent;
import java.lang.reflect.*;
import org.json.*;

public class P9AccessibilityAudit {
  static String P="vn.power9.power9_office_routine";
  static String safe(CharSequence s) { if(s==null)return ""; String v=s.toString();return v.contains("@")||v.matches(".*[A-Za-z0-9_-]{45,}.*")?"[private]":v; }
  static JSONObject node(AccessibilityNodeInfo n) throws Exception {
    JSONObject o=new JSONObject();o.put("text",safe(n.getText()));o.put("hint",safe(n.getHintText()));o.put("description",safe(n.getContentDescription()));o.put("class",String.valueOf(n.getClassName()));o.put("clickable",n.isClickable());o.put("enabled",n.isEnabled());o.put("selected",n.isSelected());o.put("accessibilityFocused",n.isAccessibilityFocused());o.put("heading",n.isHeading());o.put("focusable",n.isFocusable());o.put("checkable",n.isCheckable());o.put("checked",n.isChecked());o.put("liveRegion",n.getLiveRegion());return o;
  }
  static void walk(AccessibilityNodeInfo n,JSONArray out) throws Exception {
    if(n==null)return;
    if(P.contentEquals(n.getPackageName()==null?"":n.getPackageName()) && n.isVisibleToUser())out.put(node(n));
    for(int i=0;i<n.getChildCount();i++){AccessibilityNodeInfo c=n.getChild(i);if(c!=null){walk(c,out);c.recycle();}}
  }
  static void collect(AccessibilityNodeInfo n,String query,java.util.ArrayList<AccessibilityNodeInfo> out) {
    if(n==null)return;String label=safe(n.getText())+" "+safe(n.getContentDescription());
    if(P.contentEquals(n.getPackageName()==null?"":n.getPackageName()) && n.isVisibleToUser() && n.isClickable() && n.isEnabled() && label.contains(query))out.add(AccessibilityNodeInfo.obtain(n));
    for(int i=0;i<n.getChildCount();i++){AccessibilityNodeInfo c=n.getChild(i);if(c!=null){collect(c,query,out);c.recycle();}}
  }
  public static void main(String[] args) throws Exception {
    HandlerThread thread=new HandlerThread("p9-a11y");thread.start();
    Class<?> connectionClass=Class.forName("android.app.UiAutomationConnection");
    Constructor<?> cc=connectionClass.getDeclaredConstructor();cc.setAccessible(true);Object connection=cc.newInstance();
    Constructor<UiAutomation> ctor=UiAutomation.class.getDeclaredConstructor(android.os.Looper.class,Class.forName("android.app.IUiAutomationConnection"));ctor.setAccessible(true);
    UiAutomation u=ctor.newInstance(thread.getLooper(),connection);
    Method connect=UiAutomation.class.getDeclaredMethod("connect",int.class);connect.setAccessible(true);connect.invoke(u,UiAutomation.FLAG_DONT_SUPPRESS_ACCESSIBILITY_SERVICES);
    android.accessibilityservice.AccessibilityServiceInfo info=u.getServiceInfo();info.flags|=android.accessibilityservice.AccessibilityServiceInfo.FLAG_RETRIEVE_INTERACTIVE_WINDOWS;u.setServiceInfo(info);SystemClock.sleep(1200);
    try {
      if(args.length>1 && args[0].equals("activate")) {
        try {u.waitForIdle(350,3000);} catch(java.util.concurrent.TimeoutException ignored) {}
        AccessibilityNodeInfo root=u.getRootInActiveWindow();java.util.ArrayList<AccessibilityNodeInfo> matches=new java.util.ArrayList<>();collect(root,args[1],matches);if(matches.isEmpty())throw new IllegalStateException("No enabled Power9 accessibility action matches requested product label");
        matches.sort((a,b)->Integer.compare((safe(a.getText())+safe(a.getContentDescription())).length(),(safe(b.getText())+safe(b.getContentDescription())).length()));AccessibilityNodeInfo target=matches.get(0);
        boolean focus=target.performAction(AccessibilityNodeInfo.ACTION_ACCESSIBILITY_FOCUS);for(int sample=0;sample<4;sample++){SystemClock.sleep(250);target.refresh();if(target.isAccessibilityFocused())break;}JSONObject out=new JSONObject();out.put("target",node(target));out.put("focusActionAccepted",focus);out.put("focusedBeforeActivation",target.isAccessibilityFocused());out.put("clickActionAccepted",target.performAction(AccessibilityNodeInfo.ACTION_CLICK));SystemClock.sleep(600);System.out.println(out.toString());if(root!=null)root.recycle();
      } else if(args.length>0 && args[0].equals("traverse")) {
        JSONArray steps=new JSONArray();
        for(int i=0;i<9;i++) {
          new ProcessBuilder("/system/bin/input","swipe","250","1100","850","1100","160").start().waitFor();SystemClock.sleep(900);
          AccessibilityNodeInfo root=u.getRootInActiveWindow();JSONArray all=new JSONArray();walk(root,all);JSONObject step=new JSONObject();step.put("rightSwipe",i+1);JSONArray focus=new JSONArray();boolean done=false;
          for(int k=0;k<all.length();k++){JSONObject n=all.getJSONObject(k);if(n.getBoolean("accessibilityFocused")){focus.put(n);if((n.getString("text")+n.getString("description")).contains("Đăng nhập với Google"))done=true;}}
          step.put("focused",focus);steps.put(step);if(root!=null)root.recycle();if(done)break;
        }
        JSONObject out=new JSONObject();out.put("steps",steps);out.put("automationPreservesAccessibilityServices",true);System.out.println(out.toString());
      } else if(args.length>0 && args[0].equals("watch")) {
        u.setOnAccessibilityEventListener(e->{try {if(P.contentEquals(e.getPackageName()==null?"":e.getPackageName()) && (e.getEventType()==AccessibilityEvent.TYPE_VIEW_ACCESSIBILITY_FOCUSED || e.getEventType()==AccessibilityEvent.TYPE_ANNOUNCEMENT)){
          JSONObject o=new JSONObject();o.put("type",AccessibilityEvent.eventTypeToString(e.getEventType()));o.put("text",safe(e.getText().toString()));o.put("description",safe(e.getContentDescription()));AccessibilityNodeInfo n=e.getSource();if(n!=null){o.put("node",node(n));n.recycle();}System.out.println(o.toString());
        }} catch(Exception ignored){} });
        SystemClock.sleep(30000);
      } else {
        AccessibilityNodeInfo root=u.getRootInActiveWindow();JSONArray ns=new JSONArray();walk(root,ns);JSONObject o=new JSONObject();o.put("power9Nodes",ns);o.put("automationPreservesAccessibilityServices",true);System.out.println(o.toString());if(root!=null)root.recycle();
      }
    } finally {Method disconnect=UiAutomation.class.getDeclaredMethod("disconnect");disconnect.setAccessible(true);disconnect.invoke(u);thread.quitSafely();}
  }
}
