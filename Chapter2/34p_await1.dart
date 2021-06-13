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
  Future.delayed(Duration(seconds: 1), () {
    print("Future!!");
  });
  print("Two");
}
