# Danh mục nguồn ZIP Stitch

ZIP gốc đã giải nén vào assets/stitch/export-original/. Nguồn được giữ nguyên; các chỉnh sửa để chuẩn hóa phải thực hiện trên bản làm việc riêng.

- 37 bộ màn có code.html và screen.png.
- 3 thư mục mô tả phong cách, không tính là màn.
- Manifest và SHA256 archive/HTML: assets/stitch/export-manifest.json.
- ZIP có mã HTML và ảnh; chưa thấy log prompt nguyên văn đầy đủ trong cấu trúc đã kiểm tra.

## Bộ UI được chọn

| Mã | Thư mục nguồn |
| --- | --- |
| S01 | i01_s01_h_m_nay |
| S02 | i01_s02_n_u_ng |
| S03 | i01_s03_th_gi_n |
| S04 | i01_s04_k_t_n_i |
| S05 | i02_s05_populated_kh_m_ph_th_i_quen |
| S06-new | i03_s06_new_ch_a_th_m |
| S06-existing | i03_s06_existing_th_m |
| S07 | i02_s07_valid_l_ch_th_i_quen |
| S08 | i02_s08_populated_l_ch_s_v_ti_n |

S06-new và S06-existing là hai biến thể cùng một chức năng S06. State phụ lấy từ các thư mục i02 còn lại; wireframe theo design/wireframe-selection.md.

## Trạng thái

Đã kiểm tra/extract/lập bảng chọn. Chưa khẳng định đã nhập tám màn vào Figma hoặc có thư viện component. S01 đã nhập và xác nhận text editable qua ảnh trước đó. MCP đã tạo session và đọc file thành công sau khi kết nối lại tài khoản.
