void main() {
  getVersionName().then((value) => {
    print(value)
  });
  print('end process');
}

Future<String> getVersionName() async{
  var versionName = await lookUpVersionName();
  return versionName;
}

String lookUpVersionName(){
  return "Android Q";
}
