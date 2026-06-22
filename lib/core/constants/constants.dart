enum Environment { dev, hml, prod }

class Constants {
  static Environment stage = Environment.dev;

  static void setStage(Environment newStage) {
    stage = newStage;
  }

  static Environment getStage() => stage;

  static String getMsUrl(String msName) => switch (stage) {
  Environment.dev => 'https://dev-$msName-415041877599.southamerica-east1.run.app',
  Environment.hml => 'https://hml-$msName-1041798165885.southamerica-east1.run.app',
  Environment.prod => 'https://subaccount.tsdtech.com.br',
};
}
