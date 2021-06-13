void main() {
    printOne();
    printTwo();
    printThree();
}

void printOne() {
  print("One");
}

void printThree(){
  print("Three");
}

void printTwo() async { 
  await Future.delayed(Duration(seconds: 2), () {
    print("Future Method");
  });
  print("Two");
}
