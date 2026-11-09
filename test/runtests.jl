# Bộ kiểm thử tự động cho đề tài DT040: Chọn đồ vật bằng nhánh và cận cho cái túi 0/1
# Sinh viên: Phạm Hoàng Tuấn Kiệt - MSSV: N24DCDT044 - Lớp: D24CQDT01-N
# Học phần: Cấu trúc dữ liệu và giải thuật (INT13185 - Nhóm 03)

using Test
include(joinpath(@__DIR__, "..", "src", "CaiTui01.jl"))
using .CaiTui01

@testset "DT040 - 12 ca chuc nang va bien hop le" begin
    # VD01 (Ví dụ 1 phiếu & Ca phiếu 5, Bài 3.3 giáo trình trang in 79 / PDF 91):
    # w=[12, 7, 11, 8, 9], v=[24, 13, 23, 15, 16], W=26 -> gia_tri=51, chon=[2, 3, 4], trong_luong=26, 12 nút vs 44 nút.
    kq1 = giai_cai_tui([12, 7, 11, 8, 9], [24, 13, 23, 15, 16], 26)
    @test [d.id for d in kq1.ds] == [3, 1, 4, 2, 5]
    @test isapprox(kq1.can_goc, 52.625; atol=1e-9)
    @test kq1.gia_tri == 51
    @test kq1.chon == [2, 3, 4]
    @test kq1.trong_luong == 26
    @test kq1.so_nut == 12
    @test kq1.so_cat_can == 4
    @test kq1.so_nut_khong_can == 44
    @test kq1.kiem_tra == true

    # VD02 (Ví dụ 2 phiếu):
    # w=[2, 3, 4], v=[4, 5, 7], W=5 -> gia_tri=9, chon=[1, 2], trong_luong=5.
    kq2 = giai_cai_tui([2, 3, 4], [4, 5, 7], 5)
    @test [d.id for d in kq2.ds] == [1, 3, 2]
    @test isapprox(kq2.can_goc, 9.25; atol=1e-9)
    @test kq2.gia_tri == 9
    @test kq2.chon == [1, 2]
    @test kq2.trong_luong == 5
    @test kq2.so_nut == 6
    @test kq2.so_cat_can == 1
    @test kq2.so_nut_khong_can == 11

    # TK01 (Tự thiết kế 1 - Bẫy tham lam tỷ lệ cao):
    # Đồ vật 2 có tỷ lệ cao nhất 13/6=2.1667; nếu tham lam lấy đồ 2 + đồ 4 được 13+6=19, nhưng bỏ đồ 2 để lấy đồ 1 + đồ 3 được 10+10=20.
    kq3 = giai_cai_tui([5, 6, 5, 4], [10, 13, 10, 6], 10)
    @test [d.id for d in kq3.ds] == [2, 1, 3, 4]
    @test isapprox(kq3.can_goc, 21.0; atol=1e-9)
    @test kq3.gia_tri == 20
    @test kq3.chon == [1, 3]
    @test kq3.trong_luong == 10
    @test kq3.so_nut < kq3.so_nut_khong_can

    # TK02 (Tự thiết kế 2 - Hòa tỷ lệ v/w và có đồ vật giá trị v=0):
    # w=[4, 2, 6, 3, 5, 4], v=[8, 4, 9, 6, 0, 6], W=9 -> đồ 1, 2, 4 cùng tỷ lệ 2.0 (tổng w=9, v=18); đồ 5 có v=0 không chọn.
    kq4 = giai_cai_tui([4, 2, 6, 3, 5, 4], [8, 4, 9, 6, 0, 6], 9)
    @test [d.id for d in kq4.ds] == [1, 2, 4, 3, 6, 5]
    @test kq4.gia_tri == 18
    @test kq4.chon == [1, 2, 4]
    @test kq4.trong_luong == 9
    @test !(5 in kq4.chon)

    # BIEN01 (Biên 1 - Ca phiếu 1: W=0):
    # Sức chứa W=0 -> chọn tập rỗng, giá trị 0, trọng lượng 0, cắt cận ngay tại gốc.
    kq5 = giai_cai_tui([12, 7, 11], [24, 13, 23], 0)
    @test kq5.gia_tri == 0
    @test isempty(kq5.chon)
    @test kq5.trong_luong == 0
    @test kq5.so_nut == 1
    @test kq5.so_cat_can == 1

    # BIEN02 (Biên 2 - Ca phiếu 2: n=1, đồ nặng hơn W):
    # w=[5], v=[9], W=4 -> không chọn được, giá trị 0, danh sách rỗng.
    kq6 = giai_cai_tui([5], [9], 4)
    @test kq6.gia_tri == 0
    @test isempty(kq6.chon)
    @test kq6.trong_luong == 0
    @test isapprox(kq6.can_goc, 7.2; atol=1e-9)

    # BIEN03 (Biên 3 - Ca phiếu 3: n=1, đồ vừa khít W):
    # w=[5], v=[9], W=5 -> chọn ID [1], giá trị 9, trọng lượng 5.
    kq7 = giai_cai_tui([5], [9], 5)
    @test kq7.gia_tri == 9
    @test kq7.chon == [1]
    @test kq7.trong_luong == 5
    @test isapprox(kq7.can_goc, 9.0; atol=1e-9)

    # KT09 (Ca phiếu 4: chọn toàn bộ đồ vật vừa khít túi):
    # w=[2, 3], v=[4, 6], W=5 -> chọn cả hai [1, 2], giá trị 10, trọng lượng 5.
    kq9 = giai_cai_tui([2, 3], [4, 6], 5)
    @test kq9.gia_tri == 10
    @test kq9.chon == [1, 2]
    @test kq9.trong_luong == 5
    @test kq9.so_nut == 5

    # KT10 (Biên giá trị tất cả đồ vật v[i]=0):
    # Mọi v[i]=0 -> cận gốc = 0 <= gia_tri_tot_nhat (0), cắt nhánh ngay tại nút gốc, trả tập rỗng.
    kq10 = giai_cai_tui([3, 4, 5], [0, 0, 0], 7)
    @test kq10.gia_tri == 0
    @test isempty(kq10.chon)
    @test kq10.trong_luong == 0
    @test kq10.so_nut == 1
    @test kq10.so_cat_can == 1

    # KT11 (Nhiều đồ vật đều nặng hơn W):
    # w=[15, 20, 30], v=[100, 150, 200], W=10 -> không đồ nào vừa túi, trả tập rỗng, giá trị 0.
    kq11 = giai_cai_tui([15, 20, 30], [100, 150, 200], 10)
    @test kq11.gia_tri == 0
    @test isempty(kq11.chon)
    @test kq11.trong_luong == 0

    # KT12 (Biên trên số lượng đồ vật n=18, W=500, w[i]<=100, v[i]<=1000):
    # 18 đồ vật, sức chứa tối đa W=500; kiểm tra hiệu quả cắt nhánh ở biên n=18 (chọn 11 đồ vật đầu tiên đạt tổng trọng lượng 495 và tổng giá trị 4330).
    w18 = [30, 40, 25, 50, 35, 60, 45, 20, 55, 70, 65, 80, 75, 90, 85, 95, 100, 50]
    v18 = [300, 380, 260, 450, 350, 510, 405, 220, 440, 560, 455, 560, 450, 540, 425, 475, 500, 200]
    kq12 = giai_cai_tui(w18, v18, 500; so_sanh_khong_can=true)
    @test kq12.gia_tri == 4330
    @test kq12.trong_luong == 495
    @test kq12.chon == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    @test kq12.so_nut < 200
    @test kq12.so_nut_khong_can > 100000

    # KT13 (Biên trên giá trị phần tử w[i]=100, v[i]=1000, W=500):
    kq13 = giai_cai_tui([100, 100, 100, 100, 100, 100], [1000, 950, 900, 850, 800, 750], 500)
    @test kq13.gia_tri == 4500
    @test kq13.trong_luong == 500
    @test kq13.chon == [1, 2, 3, 4, 5]
end

@testset "DT040 - Kiem tra du lieu vao (LOI01..LOI11) va ham phu (HP01..HP05)" begin
    # LOI01: Trọng lượng âm w[2]=-3 (minh họa trong A08)
    @test_throws ArgumentError giai_cai_tui([4, -3, 5], [8, 6, 9], 10)
    # LOI02: Trọng lượng bằng 0 (vi phạm w[i] >= 1, tránh chia 0 khi tính tỷ lệ v/w)
    @test_throws ArgumentError giai_cai_tui([0, 5], [10, 20], 10)
    # LOI03: Trọng lượng vượt biên 100
    @test_throws ArgumentError giai_cai_tui([101, 5], [10, 20], 10)
    # LOI04: Giá trị âm v[1]=-1
    @test_throws ArgumentError giai_cai_tui([4, 5], [-1, 20], 10)
    # LOI05: Giá trị vượt biên 1000
    @test_throws ArgumentError giai_cai_tui([4, 5], [1001, 20], 10)
    # LOI06: Sức chứa W âm
    @test_throws ArgumentError giai_cai_tui([4, 5], [10, 20], -1)
    # LOI07: Sức chứa W vượt biên 500
    @test_throws ArgumentError giai_cai_tui([4, 5], [10, 20], 501)
    # LOI08: Mảng rỗng n=0 (vi phạm 1 <= n <= 18)
    @test_throws ArgumentError giai_cai_tui(Int[], Int[], 10)
    # LOI09: Số đồ vật n=19 vượt biên 18
    @test_throws ArgumentError giai_cai_tui(ones(Int, 19), ones(Int, 19), 10)
    # LOI10: Hai mảng w và v lệch độ dài
    @test_throws ArgumentError giai_cai_tui([2, 3], [4, 5, 6], 5)
    # LOI11: Phần tử không nguyên (số thực hoặc Bool)
    @test_throws ArgumentError giai_cai_tui([2.5, 3.0], [4, 5], 5)

    # HP01: kiem_tra_tap phát hiện ID lặp [2, 2] (vi phạm tính chất 0/1)
    @test !kiem_tra_tap([2, 2], [2, 3, 4], [4, 5, 7], 10).hop_le
    # HP02: kiem_tra_tap phát hiện ID không sắp tăng dần [3, 1]
    @test !kiem_tra_tap([3, 1], [2, 3, 4], [4, 5, 7], 10).hop_le
    # HP03: kiem_tra_tap phát hiện ID ngoài miền 1..n
    @test !kiem_tra_tap([1, 4], [2, 3, 4], [4, 5, 7], 10).hop_le
    # HP04: kiem_tra_tap phát hiện tổng trọng lượng vượt sức chứa W
    @test !kiem_tra_tap([1, 2, 3], [2, 3, 4], [4, 5, 7], 5).hop_le
    # HP05: can_tren tính đúng phần lẻ phân số của đồ vật cuối nhưng không làm tròn sai
    ds_hp = sap_theo_ty_le([12, 7, 11, 8, 9], [24, 13, 23, 15, 16])
    @test isapprox(can_tren(ds_hp, 1, 26, 0), 23 + 24 + 15 * (3 / 8); atol=1e-9)
end

println("DA QUA 12 CA CHUC NANG/BIEN VA 16 CA VALIDATOR/HAM PHU (TONG 28 CA).")
