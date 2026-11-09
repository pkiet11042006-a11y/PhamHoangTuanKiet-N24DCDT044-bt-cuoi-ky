# Chương trình minh họa và nhập bàn phím cho đề tài DT040
# Sinh viên: Phạm Hoàng Tuấn Kiệt - MSSV: N24DCDT044 - Lớp: D24CQDT01-N
# Học phần: Cấu trúc dữ liệu và giải thuật (INT13185 - Nhóm 03)

include(joinpath(@__DIR__, "src", "CaiTui01.jl"))
using .CaiTui01
using Printf

function in_ket_qua(ma_ca::AbstractString, mo_ta::AbstractString, w::Vector{Int}, v::Vector{Int}, W::Int)
    kq = giai_cai_tui(w, v, W; so_sanh_khong_can=true)
    n = length(w)
    println("DT040 - CHON DO VAT BANG NHANH VA CAN CHO CAI TUI 0/1")
    println("Ca kiem: $ma_ca - $mo_ta")
    println("Input : n=$n; w=$w; v=$v; W=$W")
    println("Bang do vat sau khi sap theo ty le v/w giam dan (giu nguyen ID goc):")
    println("Thu tu | ID goc | Trong luong w | Gia tri v | Ty le v/w")
    for (idx, d) in enumerate(kq.ds)
        @printf("%6d | %6d | %13d | %9d | %9.4f\n", idx, d.id, d.w, d.v, d.ty_le)
    end
    @printf("Can tren phan so tai nut goc (i=1, suc_con=%d): %.4f\n", W, kq.can_goc)
    println("Gia tri lon nhat : ", kq.gia_tri)
    println("Danh sach ID chon: ", kq.chon)
    println("Tong trong luong : ", kq.trong_luong, " / ", W)
    println("Kiem tra tap 0/1 : ", kq.kiem_tra ? "HOP LE" : "SAI")
    println("So nut nhanh can : ", kq.so_nut, " (cat can: ", kq.so_cat_can, " nhanh)")
    println("So nut khong can : ", kq.so_nut_khong_can)
    return kq
end

function nhap_ban_phim()
    println("Nhap n va W (vi du: 5 26):")
    nw = parse.(Int, split(strip(readline())))
    length(nw) == 2 || throw(ArgumentError("can nhap dung 2 so nguyen n va W"))
    n, W = nw
    println("Nhap $n trong luong w[1..$n] cach nhau boi khoang trang:")
    w = parse.(Int, split(strip(readline())))
    length(w) == n || throw(ArgumentError("so phan tu mang w phai bang n=$n"))
    println("Nhap $n gia tri v[1..$n] cach nhau boi khoang trang:")
    v = parse.(Int, split(strip(readline())))
    length(v) == n || throw(ArgumentError("so phan tu mang v phai bang n=$n"))
    in_ket_qua("NHAP_BAN_PHIM", "Du lieu nhap tu stdin", w, v, W)
end

function minh_hoa_du_lieu_sai()
    println("DT040 - MINH HOA TU CHOI DU LIEU KHONG HOP LE (LOI01)")
    println("Ca kiem: LOI01 - Trong luong am w[2]=-3 vi pham mien w[i] in 1..100")
    println("Input : w=[4, -3, 5]; v=[8, 6, 9]; W=10")
    println("Mong doi: kiem_tra_dau_vao nem ArgumentError tu choi trong luong khong nguyen duong.")
    try
        giai_cai_tui([4, -3, 5], [8, 6, 9], 10)
    catch loi
        if loi isa ArgumentError && occursin("trong luong", sprint(showerror, loi))
            println("DA TU CHOI DU LIEU: ", sprint(showerror, loi))
            println("KET QUA MINH HOA: DUNG; validator da chan input sai truoc khi chay nhanh can.")
            println("Ma thoat 0 chi danh cho demo bat dung ngoai le du kien.")
            return nothing
        end
        rethrow()
    end
    error("LOI: chuong trinh da chap nhan du lieu khong hop le")
end

if "--nhap" in ARGS
    nhap_ban_phim()
elseif any(startswith("--ca="), ARGS)
    ca = only(filter(startswith("--ca="), ARGS))
    if ca == "--ca=1"
        in_ket_qua("VD01", "Vi du 1 tren phieu va Bai 3.3 giao trinh (5 do vat, W=26)",
                   [12, 7, 11, 8, 9], [24, 13, 23, 15, 16], 26)
    elseif ca == "--ca=2"
        in_ket_qua("VD02", "Vi du 2 tren phieu (3 do vat, chon 2 do dau tot hon do thu 3)",
                   [2, 3, 4], [4, 5, 7], 5)
    elseif ca == "--ca=3"
        in_ket_qua("TK01", "Tu thiet ke 1: Bay tham lam ty le cao (w=6,v=13) thua cap (w=5,v=10)+(w=5,v=10)",
                   [5, 6, 5, 4], [10, 13, 10, 6], 10)
    elseif ca == "--ca=4"
        in_ket_qua("TK02", "Tu thiet ke 2: Nhieu do vat cung ty le v/w va co do vat gia tri v=0",
                   [4, 2, 6, 3, 5, 4], [8, 4, 9, 6, 0, 6], 9)
    elseif ca == "--ca=5"
        in_ket_qua("BIEN01", "Bien 1 (Ca phieu 1): Suc chua W=0, chon tap rong, gia tri 0",
                   [12, 7, 11], [24, 13, 23], 0)
    elseif ca == "--ca=6"
        in_ket_qua("BIEN02", "Bien 2 (Ca phieu 2): Mot do vat n=1 nang hon suc chua w=[5], v=[9], W=4",
                   [5], [9], 4)
    elseif ca == "--ca=7"
        in_ket_qua("BIEN03", "Bien 3 (Ca phieu 3): Mot do vat n=1 vua khit suc chua w=[5], v=[9], W=5",
                   [5], [9], 5)
    elseif ca == "--ca=8"
        minh_hoa_du_lieu_sai()
    else
        throw(ArgumentError("Tham so khong hop le: chi chon --ca=1 den --ca=8 hoac --nhap"))
    end
else
    # Mặc định chạy hai ví dụ trên phiếu giao đề tài DT040
    in_ket_qua("VD01", "Vi du 1 tren phieu va Bai 3.3 giao trinh (5 do vat, W=26)",
               [12, 7, 11, 8, 9], [24, 13, 23, 15, 16], 26)
    println("\n--- VI DU 2 TREN PHIEU GIAO DE TAI DT040 ---")
    in_ket_qua("VD02", "Vi du 2 tren phieu (3 do vat, chon 2 do dau tot hon do thu 3)",
               [2, 3, 4], [4, 5, 7], 5)
end
