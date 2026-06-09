enum Environment { dev, hml, prod }
class Constants {


  static Environment stage = Environment.dev;

  static void setStage (Environment newStage) {
    stage = newStage;
  }

  static Environment getStage() => stage;

  static String getMsUrl(String msName) => switch (stage) {
    Environment.dev => 'http://localhost:8080',
    Environment.hml => 'https://hml-$msName-1041798165885.southamerica-east1.run.app',
    _ => throw ArgumentError('Invalid stage: $stage'),
  };
}
