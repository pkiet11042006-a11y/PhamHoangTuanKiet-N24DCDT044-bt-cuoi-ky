# Lần vết chi tiết từng nút của VD01 (5 đồ vật, W=26) và khảo sát 3 quy mô n=6, 12, 18
# trên 3 cấu hình tỷ lệ (Phân hóa mạnh / Tương quan chặt / Đồng nhất tỷ lệ)
# Sinh viên: Phạm Hoàng Tuấn Kiệt - MSSV: N24DCDT044 - Lớp: D24CQDT01-N

include(joinpath(@__DIR__, "..", "src", "CaiTui01.jl"))
using .CaiTui01
using Printf

function in_trace_vd01()
    w = [12, 7, 11, 8, 9]
    v = [24, 13, 23, 15, 16]
    W = 26
    ds = sap_theo_ty_le(w, v)
    n = length(ds)

    println("TRACE_VD01 | w=$w; v=$v; W=$W")
    println("Bang do vat sau khi sap theo ty le v/w giam dan:")
    for (idx, d) in enumerate(ds)
        @printf("  Vi tri %d: ID=%d, w=%d, v=%d, ty_le=%.4f\n", idx, d.id, d.w, d.v, d.ty_le)
    end
    println("Buoc | i | Quyet_dinh_nhanh | w_ht | v_ht | suc_con | can_tren | ky_luc | Hanh_dong")

    chon_ht = zeros(Bool, n)
    chon_tot = zeros(Bool, n)
    w_ht = 0
    v_ht = 0
    v_tot = 0
    buoc = 0
    cat_can = 0

    function trace_dfs(i::Int, nhanh_str::String)
        buoc += 1
        if v_ht > v_tot
            v_tot = v_ht
            copyto!(chon_tot, chon_ht)
        end
        if i > n
            @printf("%4d | %d | %-16s | %4d | %4d | %7d | %8s | %6d | Nut la\n",
                    buoc, i, nhanh_str, w_ht, v_ht, W - w_ht, "-", v_tot)
            return nothing
        end
        ub = can_tren(ds, i, W - w_ht, v_ht)
        if ub <= v_tot + 1e-9
            cat_can += 1
            @printf("%4d | %d | %-16s | %4d | %4d | %7d | %8.4f | %6d | CAT CAN (ub <= %d)\n",
                    buoc, i, nhanh_str, w_ht, v_ht, W - w_ht, ub, v_tot, v_tot)
            return nothing
        end
        co_the_chon = (w_ht + ds[i].w <= W)
        hanh_dong = co_the_chon ? "Mo nhanh chon/bo ID=$(ds[i].id)" : "Qua nang (w=$(ds[i].w)>$(W-w_ht)), chi thu bo ID=$(ds[i].id)"
        @printf("%4d | %d | %-16s | %4d | %4d | %7d | %8.4f | %6d | %s\n",
                buoc, i, nhanh_str, w_ht, v_ht, W - w_ht, ub, v_tot, hanh_dong)

        if co_the_chon
            chon_ht[i] = true
            w_ht += ds[i].w
            v_ht += ds[i].v
            if v_ht > v_tot
                v_tot = v_ht
                copyto!(chon_tot, chon_ht)
            end
            trace_dfs(i + 1, nhanh_str * "+ID$(ds[i].id)")
            v_ht -= ds[i].v
            w_ht -= ds[i].w
            chon_ht[i] = false
        end
        trace_dfs(i + 1, nhanh_str * "-ID$(ds[i].id)")
        return nothing
    end

    trace_dfs(1, "Goc")
    kq = giai_cai_tui(w, v, W; so_sanh_khong_can=true)
    chon_id = sort([ds[i].id for i in 1:n if chon_tot[i]])
    @assert buoc == kq.so_nut && cat_can == kq.so_cat_can && v_tot == kq.gia_tri && chon_id == kq.chon
    println("Doi chieu voi giai_cai_tui: DUNG; so_nut=$buoc, so_cat_can=$cat_can, gia_tri=$v_tot, chon=$chon_id, so_nut_khong_can=$(kq.so_nut_khong_can)")
end

function in_scales()
    println("\nSCALE | bo_q | cau_hinh | n | W | gia_tri | trong_luong | so_nut_co_can | so_cat_can | so_nut_khong_can | ti_le_giam_nut")
    for (idx_q, n) in enumerate([6, 12, 18])
        bo_q = "Q$idx_q"
        for cau_hinh in ["Phan_hoa_manh", "Tuong_quan_chat", "Dong_nhat_ty_le"]
            w = [10 + ((i * 7) % 25) for i in 1:n]
            if cau_hinh == "Phan_hoa_manh"
                # Tỷ lệ v/w giảm mạnh từ ~10 xuống ~1 giúp cận trên rất sát và cắt nhánh cực sớm
                v = [w[i] * max(1, 11 - div(i, 2)) for i in 1:n]
            elseif cau_hinh == "Tuong_quan_chat"
                # Giá trị v[i] = 3*w[i] + (i % 5), tỷ lệ v/w gần nhau nhưng có chênh lệch nhỏ
                v = [3 * w[i] + (i % 5) for i in 1:n]
            else
                # Đồng nhất tỷ lệ v/w = 4 cho mọi đồ vật
                v = [4 * w[i] for i in 1:n]
            end
            W = min(500, div(sum(w), 2))
            kq = giai_cai_tui(w, v, W; so_sanh_khong_can=true)
            ti_le = round(100.0 * (1.0 - kq.so_nut / kq.so_nut_khong_can); digits=2)
            println("SCALE | $bo_q | $cau_hinh | $n | $W | $(kq.gia_tri) | $(kq.trong_luong) | $(kq.so_nut) | $(kq.so_cat_can) | $(kq.so_nut_khong_can) | $(ti_le)%")
        end
    end
end

in_trace_vd01()
in_scales()
