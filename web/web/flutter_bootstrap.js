{{flutter_js}}
{{flutter_build_config}}

// Use a fresh URL to replace copies cached before Hosting revalidation.
for (const build of _flutter.buildConfig.builds) {
  if (build.mainJsPath) {
    build.mainJsPath += '?v=review-layout-2';
  }
}

_flutter.loader.load();
