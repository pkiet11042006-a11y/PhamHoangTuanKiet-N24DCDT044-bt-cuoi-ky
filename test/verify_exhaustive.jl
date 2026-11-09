# Oracle độc lập: Vét cạn mọi tập con (bitmask 0..2^n-1) và Quy hoạch động 0/1,
# không gọi nhánh và cận để tự tạo expected cho nhánh và cận.
# Sinh viên: Phạm Hoàng Tuấn Kiệt - MSSV: N24DCDT044 - Lớp: D24CQDT01-N

include(joinpath(@__DIR__, "..", "src", "CaiTui01.jl"))
using .CaiTui01

function oracle_vet_can(w::Vector{Int}, v::Vector{Int}, W::Int)
    n = length(w)
    best_v = 0
    for mask in 0:((1 << n) - 1)
        tw = 0
        tv = 0
        for i in 1:n
            if ((mask >> (i - 1)) & 1) == 1
                tw += w[i]
                tv += v[i]
            end
        end
        if tw <= W && tv > best_v
            best_v = tv
        end
    end
    return best_v
end

function verify_all()
    # 1. Đối chiếu vét mọi tập con 2^5 = 32 trên ví dụ 5 đồ vật trong sách (Bước 5 trên phiếu)
    w_sach = [12, 7, 11, 8, 9]
    v_sach = [24, 13, 23, 15, 16]
    W_sach = 26
    expected_sach = oracle_vet_can(w_sach, v_sach, W_sach)
    kq_sach = giai_cai_tui(w_sach, v_sach, W_sach)
    @assert expected_sach == 51
    @assert kq_sach.gia_tri == expected_sach
    @assert kq_sach.chon == [2, 3, 4]
    @assert kq_sach.trong_luong == 26
    @assert kq_sach.so_nut == 12
    @assert kq_sach.so_nut_khong_can == 44

    # 2. Đối chiếu vét cạn trên họ bài toán tất định với n = 1..8 (480 cấu hình, 43.260 tập con)
    so_cau_hinh = 0
    tong_tap_con = 0
    for n in 1:8
        for mau in 1:6
            w = [((i * 7 + mau * 3) % 15) + 1 for i in 1:n]
            v = [((i * 13 + mau * 11) % 40) for i in 1:n]
            tong_w = sum(w)
            for W in [0, 1, div(tong_w, 4), div(tong_w, 2), div(3 * tong_w, 4),
                      max(0, tong_w - 1), tong_w, min(500, tong_w + 5), 10, 25]
                expected = oracle_vet_can(w, v, W)
                got = giai_cai_tui(w, v, W; so_sanh_khong_can=true)
                @assert got.gia_tri == expected "Sai gia tri tai n=$n mau=$mau W=$W"
                @assert got.kiem_tra "Tap chon khong hop le tai n=$n mau=$mau W=$W"
                @assert sum(Int[w[id] for id in got.chon]) == got.trong_luong
                @assert sum(Int[v[id] for id in got.chon]) == got.gia_tri
                @assert got.trong_luong <= W
                @assert issorted(got.chon) && allunique(got.chon)
                @assert got.so_nut <= got.so_nut_khong_can
                so_cau_hinh += 1
                tong_tap_con += (1 << n)
            end
        end
    end
    println("EXHAUSTIVE_OK instances=$so_cau_hinh subsets_checked=$tong_tap_con n=1..8")
    println("ORACLE=Bitmask_Exhaustive_2^n; textbook_5_items_subsets=32 best_val=51 nodes_bb=12 nodes_no_bound=44")
    println("All selected sets verified: 0/1 uniqueness, ascending IDs, weight <= W, value == oracle optimal.")
end

verify_all()
