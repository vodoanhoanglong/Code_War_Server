SET check_function_bodies = false;
INSERT INTO public.account (id, email, "fullName", password, "avatarUrl", role, birthday, gender, "hashedToken", alias, status, "createdAt", "updatedAt", "createdBy", "updatedBy") VALUES ('44bfcc07-a81a-45da-aa65-9197a3300f62', 'moderator@gmail.com', 'moderator', '$2a$10$YmasfIkbgx.04zamgALAMeXeL9ttwLrcqWS0QV2Iz7o.DjTYmqu.6', NULL, 'moderator', NULL, NULL, 'JDJhJDEwJDhhRlNDWXFqb1BtczYxLkNmUWc2WGVMN3JXYnFOcTY5OWxETzU0a1JSaDVNbXBuajJvTEVL', NULL, 'active', '2022-05-15 04:04:14.895822+00', '2022-05-15 04:04:14.895822+00', NULL, NULL);
INSERT INTO public.account (id, email, "fullName", password, "avatarUrl", role, birthday, gender, "hashedToken", alias, status, "createdAt", "updatedAt", "createdBy", "updatedBy") VALUES ('de10facf-22f2-4273-a038-9472b807a512', 'admin@gmail.com', 'admin', '$2a$10$KEBU3xAB0L6WnU.JTHEdv.i0anNhIxl23mVVbVpspa1zITjXRyYZ6', NULL, 'admin', NULL, NULL, 'JDJhJDEwJGFYbXJheFNPc0N6VTVKSjZqU014ZWUuUkl3cnIvei84R2haeElzS1B5dldrblVNcVJXcklH', NULL, 'active', '2022-05-15 04:04:44.722676+00', '2022-05-15 04:04:44.722676+00', NULL, NULL);
INSERT INTO public.account (id, email, "fullName", password, "avatarUrl", role, birthday, gender, "hashedToken", alias, status, "createdAt", "updatedAt", "createdBy", "updatedBy") VALUES ('545fbcb9-4437-4406-9248-e7f1efda55b9', 'user@gmail.com', 'user', '$2a$10$AAtrp4vGFYuVdexfkkju4eVGGx9a1GJ60BzVaL4Ne4p1EyEo4muRu', NULL, 'user', NULL, NULL, 'JDJhJDEwJEs1dWZGc0ZuODdpMlowb2J5Q2dOSnUzODhNa3JMRjdLRkZ6dGVNUEJucy9aRjRLWS55L1hX', NULL, 'active', '2022-05-15 04:04:54.317117+00', '2022-05-15 04:04:54.317117+00', NULL, NULL);

INSERT INTO public.exercises (id, name, des, level, image, metadata, topic, status, "createdAt", "createdBy", "updatedAt", "updatedBy") VALUES ('86d8b40f-49ab-489d-94d2-fed37f94b66f', 'Làm quen với C++', 'In ra màn hình câu "Hello World"', 1, NULL, '[{"time": 1000, "input": null, "point": 10, "output": "hello world"}]', '["C++"]', 'active', '2022-04-25 14:12:57.872723+00', NULL, '2022-04-25 14:12:57.872723+00', NULL);
INSERT INTO public.exercises (id, name, des, level, image, metadata, topic, status, "createdAt", "createdBy", "updatedAt", "updatedBy") VALUES ('8639eb5e-4286-4a03-80a8-3a96ae6d0473', 'Phép cộng', 'Bạn hãy viết chương trình tạo ra 2 biến `a` và `b` kiểu số nguyên. Sau đó nhập giá trị cho `a` và `b` từ bàn phím và hiển thị ra màn hình:
```
a + b = {P}
```
Với `{P}` là tổng của `a` và `b`.
Ví dụ nếu bạn nhập
```
7 9
```
thì màn hình sẽ hiển thị ra:
```
a + b = 16
```
#### Lý thuyết
Nhập dữ liệu cho biến kiểu `int` cũng giống như nhập dữ liệu cho biến kiểu `string`. Ví dụ về chương trình nhập từ bàn phím 2 số nguyên và hiển thị ra hiệu của chúng:
```
#include<iostream>
using namespace std;
int main() {
	int a, b;
	cin >> a >> b;
	cout << "a - b = " << a - b;
	return 0;
}
```
Nếu bạn nhập
```
5 8
```
Và bấm phím Enter thì chương trình này sẽ hiển thị lên màn hình:
```
a - b = -3
```
Lưu ý: nếu bạn nhập giá trị không hợp lệ cho các biến kiểu số thì giá trị nhận được sẽ là `0`. Ví dụ nếu bạn nhập giá trị cho biến `a` kiểu `int` là `"abc"`, `"xyz"`, ... thì `a` sẽ nhận giá trị 0.
Đọc tới đây bạn đã có thể quay lại phần bài tập và làm thử.
### Hướng dẫn
Code mẫu:
```
#include<iostream>
using namespace std;
int main() {
	int a, b;
	cin >> a >> b;
	cout << "a + b = " << a + b;
	return 0;
}
```', 1, NULL, '[{"time": 1000, "input": "5 5", "point": 5, "output": "10"}, {"time": 1500, "input": "8 7", "point": 5, "output": "15"}]', '["C++"]', 'active', '2022-05-02 10:33:48.845567+00', NULL, '2022-05-02 10:33:48.845567+00', NULL);
INSERT INTO public.exercises (id, name, des, level, image, metadata, topic, status, "createdAt", "createdBy", "updatedAt", "updatedBy") VALUES ('c260acdf-5436-47e0-8dcc-c2f1767ff82d', 'Odd Divisor Count', 'Bạn được cho 2 số nguyên `A,B.` Bạn hãy đếm số lượng số trong `[A,B]` sao cho số đó có số lượng lẻ ước nguyên dương.
Ví dụ:
-   Với `A = 4, B = 4` thì ta có đáp án là 1 số thỏa điều kiện.
-   Giải thích: 4 có 3 ước là `1,2,4` nên thỏa điều kiện để bài.
[Đầu vào/ Đầu ra]:
-   [Giới hạn thời gian]: 0.5s với C++, 3s với Java & C#, 4s với Python,Go,Js.
-   [Đầu vào]: Số tự nhiên a `(1 ≤ a ≤ 1000).`
-   [Đầu vào]: Số tự nhiên b `(a ≤ b ≤ 1000).`
-   [Đầu ra]: Số lượng số trong [a,b] sao cho số đó có số lượng lẻ ước nguyên dương.', 2, NULL, '[{"time": 1000, "input": "4 4", "point": 2, "output": "1"}, {"time": 1500, "input": "1 10", "point": 2, "output": "3"}, {"time": 2000, "input": "5 15", "point": 2, "output": "1"}, {"time": 2500, "input": "50 120", "point": 2, "output": "3"}, {"time": 3000, "input": "45 130", "point": 2, "output": "5"}]', '["C++"]', 'active', '2022-04-25 14:33:30.481496+00', NULL, '2022-04-25 14:33:30.481496+00', NULL);

INSERT INTO public.discusses (id, floor, title, content, status, "createdAt", "createdBy", "updatedAt", "updatedBy", "accountId", "exerciseId") VALUES ('51882cbf-f13c-41c4-9769-0e65f52d4a94', NULL, NULL, 'How to do this', 'active', '2022-05-15 14:26:25.422707', NULL, '2022-05-15 14:26:25.422707+00', NULL, '545fbcb9-4437-4406-9248-e7f1efda55b9', '8639eb5e-4286-4a03-80a8-3a96ae6d0473');
INSERT INTO public.discusses (id, floor, title, content, status, "createdAt", "createdBy", "updatedAt", "updatedBy", "accountId", "exerciseId") VALUES ('cd1ad0a5-a54c-45c7-98fd-2cfa2356140b', NULL, NULL, 'Why', 'active', '2022-05-15 14:26:39.698707', NULL, '2022-05-15 14:26:39.698707+00', NULL, '545fbcb9-4437-4406-9248-e7f1efda55b9', '8639eb5e-4286-4a03-80a8-3a96ae6d0473');
INSERT INTO public.discusses (id, floor, title, content, status, "createdAt", "createdBy", "updatedAt", "updatedBy", "accountId", "exerciseId") VALUES ('4775ded2-9d76-4254-b97e-becbae5c1996', NULL, NULL, 'What the ....', 'active', '2022-05-15 14:26:45.648362', NULL, '2022-05-15 14:26:45.648362+00', NULL, '545fbcb9-4437-4406-9248-e7f1efda55b9', '8639eb5e-4286-4a03-80a8-3a96ae6d0473');
