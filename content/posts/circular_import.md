---
title: "Circular import에 대한 생각"
description: "Circular import 문제를 해결하기 위한 방법."
date: 2021-02-21T13:34:20+09:00
tags: ["python", "coding"]

showToc: false
TocOpen: false
draft: false
hidemeta: false
comments: false
disableHLJS: true # to disable highlightjs
disableShare: false
disableHLJS: false
searchHidden: true
---

인터넷을 보면 많은 circular import 문제 해결 방법을 찾을 수 있다.

대표적인 해결방법.

```python
def foo():
    import smth
    ...
```

위와 같이 함수 내부에서 import 를 한다면 **회피**가 가능하다.

프로그램은 문제 없이 동작하기 시작하고, 이후 이 문제는 그대로 잊혀진다.

이게 옳은 방법일까?

일단 해당 문제가 왜 발생하는 지부터 생각해보자.

```python
# foo.py
import bar
...

# bar.py
import foo
...
```

이렇게 서로를 import 하는 경우 발생한다. 개발을 하다보면 흔하게 발생하는 경우인데, 단순히 위에 소개한 방법으로 회피하는 것만 고려하여 아쉬움이 있다.

프로그램이 커지다보면 계층구조를 띄게 된다.
```
|  # 최상위 모듈
|  # 상위 모듈
|  # 중위 모듈
|  # 하위 모듈
v  # 최하위 모듈
```
이런 구조가 가장 가독성이 좋고 모듈의 배치가 설명 가능한 구조라고 생각한다. 하지만 순환 참조 문제가 발생한 구조는
```
|<-+  # 최상위 모듈
|  |  # 상위 모듈
+--+  # 중위 모듈
|     # 하위 모듈
v     # 최하위 모듈
```
로 구성을 시도한 경우이다. 이 경우는 위의 계층 구조를 거스르는 것일 뿐만 아니라, 타 작업자로 하여금 중위 모듈에서 다시 최상위 모듈을 살펴봐야하는 번거로움을 지게 한다. 가독성을 해치게 되는 것이다. 또한 이러한 일이 반복되면 루프의 루프가 겹치게 되어 순환 참조를 끊어내기 힘든 상황이 발생한다.

그렇기에 순환 참조의 문제가 발생한다면, 그것은 **회피**를 고려해야하는 문제가 아니라 **계층 구조**를 고려해야하는 문제인 것이다.

이러한 일이 발생한다면 
1. 내가 사용하려는 함수의 위치를 상위로 조정해보자. (상위에서 하위의 함수를 써야한다면 쓰고자하는 함수는 더이상 하위에 있을 이유가 없다.)
2. 재사용성을 포기한다. (도메인에 귀속되어 위치 조정이 힘들다면 고려해봄직하다.)

이 후에 함수내 import를 고려해야한다고 생각한다.

정리하자면, 프로그램의 계층 구조를 해치는 고민은 가장 늦게 해야만 한다.