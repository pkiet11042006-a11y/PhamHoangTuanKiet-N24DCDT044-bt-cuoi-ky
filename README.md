# DT040 — Chọn đồ vật bằng nhánh và cận cho cái túi 0/1

Báo cáo và mã nguồn đồ án cá nhân học phần **Cấu trúc dữ liệu và giải thuật (`INT13185` — Nhóm 03)**.

## Thông tin và căn cứ

- **Họ tên, MSSV, lớp**: Phạm Hoàng Tuấn Kiệt — `N24DCDT044` — `D24CQDT01-N`.
- **Mã và tên đề tài**: `DT040` — Chọn đồ vật bằng nhánh và cận cho cái túi 0/1.
- **Giảng viên hướng dẫn**: Hồ Nhựt Minh.
- **Giáo trình**: `Giao-trinh-Cau-truc-du-lieu-va-Giai-thuat-INT1306.pdf`, Chương 3, Bài 3.3 Cái túi bằng nhánh và cận; Bài tập chương 3, câu 30; trang in 79, 86; trang PDF 91, 98.
- **Phiên bản Julia kiểm chứng**: `Julia 1.12.7` (chỉ sử dụng thư viện chuẩn `Test` và `Printf`, không phụ thuộc gói ngoài hay tệp dữ liệu CSV/Excel).

## Cấu trúc mã nguồn

| Tệp | Trách nhiệm |
|---|---|
| `src/CaiTui01.jl` | Module `CaiTui01` cài đặt cấu trúc `DoVat`, `kiem_tra_dau_vao`, `sap_theo_ty_le`, `can_tren`, `thu_cai_tui`, `kiem_tra_tap`, `giai_cai_tui` |
| `demo.jl` | Chạy 8 ca minh họa (`--ca=1` đến `--ca=8`), chạy mặc định 2 ví dụ trên phiếu hoặc nhập trực tiếp từ bàn phím (`--nhap`) |
| `test/runtests.jl` | Bộ kiểm thử tự động gồm 12 ca chức năng/biên (`VD01..KT13`) và 16 ca validator/hàm phụ (`LOI01..LOI11`, `HP01..HP05`), tổng cộng 28 ca định danh và 77 phép `@test` / `@test_throws` |
| `test/verify_exhaustive.jl` | Oracle độc lập vét cạn mọi tập con $2^n$ (bitmask) kiểm chứng ví dụ 5 đồ vật trong sách (32 tập con, 12 nút có cận so với 44 nút không cận) và 480 cấu hình bài toán nhỏ ($n=1..8$) |
| `scripts/test_catalog.jl` | Xuất bảng đối chiếu `input / expected / actual / PASS` cho toàn bộ 28 ca kiểm thử có định danh |
| `scripts/trace_and_scales.jl` | Tái hiện bảng truy vết từng bước (12 nút) của Ví dụ 1 (`VD01`) và khảo sát 3 quy mô hợp lệ $Q_1 (n=6), Q_2 (n=12), Q_3 (n=18)$ trên 3 cấu hình tỷ lệ |
| `Run_all.ps1` | Kịch bản PowerShell chạy toàn bộ phiên bản, 8 ca demo, bộ kiểm thử, oracle vét cạn, catalog và khảo sát quy mô bằng một lệnh duy nhất |
| `docs/anh_ket_qua/` | Bộ 11 ảnh bằng chứng thực thi `A01–A11` (`01_vi_du_1.png` .. `11_github_repo_commit.png`) và 2 sơ đồ minh họa |
| `docs/logs/` | Nhật ký kết quả thực chạy nguyên văn từ terminal |

## Hợp đồng đầu vào và đầu ra

- **Đầu vào**:
  - Số đồ vật $n \in [1, 18]$, hai mảng một chiều $w, v$ cùng độ dài $n$.
  - Trọng lượng nguyên dương $w[i] \in [1, 100]$, giá trị nguyên không âm $v[i] \in [0, 1000]$, sức chứa nguyên $W \in [0, 500]$.
  - Mọi dữ liệu vi phạm kiểu hoặc miền đều bị `kiem_tra_dau_vao` từ chối ngay bằng `ArgumentError`.
- **Thuật toán**:
  - Lưu mỗi đồ vật cùng ID gốc (`1..n`), trọng lượng `w`, giá trị `v` và sắp xếp theo tỷ lệ $v[i]/w[i]$ giảm dần (so sánh chính xác bằng tích chéo $v_a w_b > v_b w_a$; khi hòa giữ thứ tự ID gốc tăng dần).
  - Hàm `can_tren` tính cận trên bằng cách lấp đầy phần sức chứa còn lại `suc_con` theo thứ tự tỷ lệ giảm dần, cho phép lấy phân số của đồ vật đầu tiên không vừa túi. Phần phân số chỉ dùng để tính cận trên.
  - Hàm `thu_cai_tui` duyệt cây nhị phân chọn/bỏ (0/1), cắt nhánh khi $\text{can\_tren} \le \text{gia\_tri\_tot\_nhat}$, đồng thời hỗ trợ chế độ `dung_can=false` để đếm số nút khi không dùng cận.
- **Đầu ra**:
  - In tổng giá trị lớn nhất `gia_tri`, danh sách ID gốc được chọn theo thứ tự tăng dần `chon`, tổng trọng lượng `trong_luong`, kết quả tự kiểm tra `kiem_tra_tap` và số nút duyệt có cận / không cận.

## Hướng dẫn chạy chương trình và kiểm thử

Mở PowerShell tại thư mục gốc của kho mã:

```powershell
# 1. Chạy toàn bộ quy trình (phiên bản, 8 ca demo, 28 ca test, oracle vét cạn, trace và khảo sát)
.\Run_all.ps1

# 2. Chạy mặc định 2 ví dụ trên phiếu giao đề tài
julia --startup-file=no demo.jl

# 3. Chạy từng ca minh họa cụ thể (A01 đến A08 tương ứng --ca=1 đến --ca=8)
julia --startup-file=no demo.jl --ca=1
julia --startup-file=no demo.jl --ca=2
julia --startup-file=no demo.jl --ca=3
julia --startup-file=no demo.jl --ca=4
julia --startup-file=no demo.jl --ca=5
julia --startup-file=no demo.jl --ca=6
julia --startup-file=no demo.jl --ca=7
julia --startup-file=no demo.jl --ca=8

# 4. Chạy chế độ nhập dữ liệu từ bàn phím (stdin)
julia --startup-file=no demo.jl --nhap

# 5. Chạy bộ kiểm thử tự động (28 ca định danh, 77 phép assert)
julia --startup-file=no test/runtests.jl

# 6. Chạy oracle đối chiếu vét cạn độc lập và xuất bảng catalog / truy vết
julia --startup-file=no test/verify_exhaustive.jl
julia --startup-file=no scripts/test_catalog.jl
julia --startup-file=no scripts/trace_and_scales.jl
```

## Kiểm tra chạy lại từ bản clone sạch

```powershell
git clone <URL_HOAC_DUONG_DAN_KHO_MA> kiem_tra_ban_nop_N24DCDT044
cd kiem_tra_ban_nop_N24DCDT044
git rev-parse HEAD
.\Run_all.ps1
```
