# Kế hoạch 11 ảnh A01–A11 cho đề tài cá nhân DT040

Bộ 11 ảnh bằng chứng thực thi và kiểm chứng cho đề tài **DT040 — Chọn đồ vật bằng nhánh và cận cho cái túi 0/1** của sinh viên **Phạm Hoàng Tuấn Kiệt** (`MSSV: N24DCDT044`, lớp `D24CQDT01-N`).

| Mã ảnh | Hình trong báo cáo | Tên tệp ảnh | Ca kiểm / Đối tượng | Mục tiêu |
|---|---|---|---|---|
| A01 | Hình 4.1 | `01_vi_du_1.png` | `VD01` | Ví dụ 1 trên phiếu & Ca phiếu 5 (Bài 3.3 giáo trình: 5 đồ vật, `W=26`, kết quả `gia_tri=51`, `chon=[2, 3, 4]`, `trong_luong=26`, `12` nút có cận so với `44` nút không cận) |
| A02 | Hình 4.2 | `02_vi_du_2.png` | `VD02` | Ví dụ 2 trên phiếu (`w=[2, 3, 4], v=[4, 5, 7], W=5`, kết quả `gia_tri=9`, `chon=[1, 2]`, `trong_luong=5`) |
| A03 | Hình 4.3 | `03_tu_thiet_ke_1.png` | `TK01` | Ca tự thiết kế 1: Bẫy tham lam tỷ lệ cao (`w=6, v=13` thua cặp `w=5, v=10` + `w=5, v=10` với `W=10`, kết quả `gia_tri=20`, `chon=[1, 3]`) |
| A04 | Hình 4.4 | `04_tu_thiet_ke_2.png` | `TK02` | Ca tự thiết kế 2: Nhiều đồ vật hòa tỷ lệ `v/w` và có đồ vật giá trị `v=0` (`w=[4, 2, 6, 3, 5, 4], v=[8, 4, 9, 6, 0, 6], W=9`, kết quả `gia_tri=18`, `chon=[1, 2, 4]`) |
| A05 | Hình 4.5 | `05_bien_1.png` | `BIEN01` | Ca biên 1 (Ca phiếu 1): Sức chứa `W=0` (`w=[12, 7, 11], v=[24, 13, 23], W=0`, chọn tập rỗng `Int64[]`, `gia_tri=0`, cắt cận ngay tại gốc) |
| A06 | Hình 4.6 | `06_bien_2.png` | `BIEN02` | Ca biên 2 (Ca phiếu 2): Một đồ vật `n=1` nặng hơn sức chứa (`w=[5], v=[9], W=4`, chọn tập rỗng `Int64[]`, `gia_tri=0`) |
| A07 | Hình 4.7 | `07_bien_3.png` | `BIEN03` | Ca biên 3 (Ca phiếu 3): Một đồ vật `n=1` vừa khít sức chứa (`w=[5], v=[9], W=5`, chọn `[1]`, `gia_tri=9`, `trong_luong=5`) |
| A08 | Hình 4.8 | `08_input_khong_hop_le.png` | `LOI01` | Input không hợp lệ: Trọng lượng âm `w[2]=-3` vi phạm miền `1 <= w[i] <= 100` bị `kiem_tra_dau_vao` từ chối bằng `ArgumentError` |
| A09 | Hình 4.9 | `09_tong_ket_kiem_thu.png` | `TEST_ALL` | Chạy `test/runtests.jl` và `scripts/test_catalog.jl`: vượt qua 28 ca định danh (12 ca chức năng/biên + 16 ca validator/hàm phụ) với 77 phép assert |
| A10 | Hình 4.10 | `10_clone_sach_chay_lai.png` | `CLONE` | Clone sạch commit `C` sang thư mục mới, kiểm tra `git rev-parse HEAD`, phiên bản Julia và chạy toàn bộ `Run_all.ps1` |
| A11 | Hình 4.11 | `11_github_repo_commit.png` | `GITHUB` | Kho mã Git / GitHub của sinh viên tại commit `C`, trạng thái sạch và danh sách tệp được theo dõi |

Ngoài 11 ảnh bằng chứng A01–A11, thư mục còn có hai sơ đồ minh họa lý thuyết/thiết kế:
- `cay_nhanh_can_vd01.png` (Hình 2.1): Cây tìm kiếm nhánh và cận 12 nút cho Ví dụ 1 (`n=5, W=26`).
- `so_do_luong_dt040.png` (Hình 3.1): Sơ đồ luồng xử lý của các hàm trong `src/CaiTui01.jl`.
