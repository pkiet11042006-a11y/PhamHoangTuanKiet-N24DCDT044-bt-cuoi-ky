# Xuất bảng tổng hợp 28 ca kiểm thử (12 ca chức năng/biên + 16 ca validator/hàm phụ)
# Sinh viên: Phạm Hoàng Tuấn Kiệt - MSSV: N24DCDT044 - Lớp: D24CQDT01-N

include(joinpath(@__DIR__, "..", "src", "CaiTui01.jl"))
using .CaiTui01

w18 = [30, 40, 25, 50, 35, 60, 45, 20, 55, 70, 65, 80, 75, 90, 85, 95, 100, 50]
v18 = [300, 380, 260, 450, 350, 510, 405, 220, 440, 560, 455, 560, 450, 540, 425, 475, 500, 200]

functional_cases = [
    ("VD01", "Vi du 1 phieu & Ca phieu 5 (Bai 3.3 sach)", [12, 7, 11, 8, 9], [24, 13, 23, 15, 16], 26, 51, [2, 3, 4], 26),
    ("VD02", "Vi du 2 phieu (3 do vat, W=5)", [2, 3, 4], [4, 5, 7], 5, 9, [1, 2], 5),
    ("TK01", "Tu thiet ke 1: Bay tham lam ty le cao", [5, 6, 5, 4], [10, 13, 10, 6], 10, 20, [1, 3], 10),
    ("TK02", "Tu thiet ke 2: Hoa ty le v/w va co v[i]=0", [4, 2, 6, 3, 5, 4], [8, 4, 9, 6, 0, 6], 9, 18, [1, 2, 4], 9),
    ("BIEN01", "Bien 1 & Ca phieu 1: Suc chua W=0", [12, 7, 11], [24, 13, 23], 0, 0, Int[], 0),
    ("BIEN02", "Bien 2 & Ca phieu 2: n=1 nang hon W", [5], [9], 4, 0, Int[], 0),
    ("BIEN03", "Bien 3 & Ca phieu 3: n=1 vua khit W", [5], [9], 5, 9, [1], 5),
    ("KT09", "Ca phieu 4: Chon tat ca do vat vua khit W", [2, 3], [4, 6], 5, 10, [1, 2], 5),
    ("KT10", "Bien gia tri tat ca v[i]=0", [3, 4, 5], [0, 0, 0], 7, 0, Int[], 0),
    ("KT11", "Tat ca do vat deu nang hon W", [15, 20, 30], [100, 150, 200], 10, 0, Int[], 0),
    ("KT12", "Bien tren n=18, W=500, w<=100, v<=1000", w18, v18, 500, 4330, collect(1:11), 495),
    ("KT13", "Bien tren w[i]=100, v[i]=1000, W=500", [100, 100, 100, 100, 100, 100], [1000, 950, 900, 850, 800, 750], 500, 4500, [1, 2, 3, 4, 5], 500)
]

println("CATALOG | id | input | expected | actual | result")
for (id, desc, w, v, W, exp_val, exp_chon, exp_wt) in functional_cases
    kq = giai_cai_tui(w, v, W; so_sanh_khong_can=true)
    ok = (kq.gia_tri == exp_val && kq.chon == exp_chon && kq.trong_luong == exp_wt && kq.kiem_tra)
    @assert ok "Failed on $id: got $kq"
    short_in = length(w) == 18 ? "n=18; W=500; w18=[30,40,...,50]; v18=[300,380,...,200]" : "w=$w; v=$v; W=$W"
    exp_str = "gia_tri=$exp_val; chon=$exp_chon; w=$exp_wt"
    act_str = "gia_tri=$(kq.gia_tri); chon=$(kq.chon); w=$(kq.trong_luong); nut=$(kq.so_nut)/$(kq.so_nut_khong_can)"
    println("CATALOG | $id | $short_in | $exp_str | $act_str | PASS")
end

function throws_arg_err(f)
    try
        f()
        return false
    catch err
        return err isa ArgumentError
    end
end

validators = [
    ("LOI01", "giai_cai_tui([4,-3,5],[8,6,9],10)", "ArgumentError (w[2]<=0)", () -> throws_arg_err(() -> giai_cai_tui([4, -3, 5], [8, 6, 9], 10))),
    ("LOI02", "giai_cai_tui([0,5],[10,20],10)", "ArgumentError (w[1]==0)", () -> throws_arg_err(() -> giai_cai_tui([0, 5], [10, 20], 10))),
    ("LOI03", "giai_cai_tui([101,5],[10,20],10)", "ArgumentError (w[1]>100)", () -> throws_arg_err(() -> giai_cai_tui([101, 5], [10, 20], 10))),
    ("LOI04", "giai_cai_tui([4,5],[-1,20],10)", "ArgumentError (v[1]<0)", () -> throws_arg_err(() -> giai_cai_tui([4, 5], [-1, 20], 10))),
    ("LOI05", "giai_cai_tui([4,5],[1001,20],10)", "ArgumentError (v[1]>1000)", () -> throws_arg_err(() -> giai_cai_tui([4, 5], [1001, 20], 10))),
    ("LOI06", "giai_cai_tui([4,5],[10,20],-1)", "ArgumentError (W<0)", () -> throws_arg_err(() -> giai_cai_tui([4, 5], [10, 20], -1))),
    ("LOI07", "giai_cai_tui([4,5],[10,20],501)", "ArgumentError (W>500)", () -> throws_arg_err(() -> giai_cai_tui([4, 5], [10, 20], 501))),
    ("LOI08", "giai_cai_tui(Int[],Int[],10)", "ArgumentError (n==0)", () -> throws_arg_err(() -> giai_cai_tui(Int[], Int[], 10))),
    ("LOI09", "giai_cai_tui(ones(19),ones(19),10)", "ArgumentError (n==19>18)", () -> throws_arg_err(() -> giai_cai_tui(ones(Int, 19), ones(Int, 19), 10))),
    ("LOI10", "giai_cai_tui([2,3],[4,5,6],5)", "ArgumentError (len(w)!=len(v))", () -> throws_arg_err(() -> giai_cai_tui([2, 3], [4, 5, 6], 5))),
    ("LOI11", "giai_cai_tui([2.5,3.0],[4,5],5)", "ArgumentError (w non-Int)", () -> throws_arg_err(() -> giai_cai_tui([2.5, 3.0], [4, 5], 5))),
    ("HP01", "kiem_tra_tap([2,2],[2,3,4],[4,5,7],10)", "hop_le=false (trung ID)", () -> !kiem_tra_tap([2, 2], [2, 3, 4], [4, 5, 7], 10).hop_le),
    ("HP02", "kiem_tra_tap([3,1],[2,3,4],[4,5,7],10)", "hop_le=false (ID giam)", () -> !kiem_tra_tap([3, 1], [2, 3, 4], [4, 5, 7], 10).hop_le),
    ("HP03", "kiem_tra_tap([1,4],[2,3,4],[4,5,7],10)", "hop_le=false (ID ngoai 1..n)", () -> !kiem_tra_tap([1, 4], [2, 3, 4], [4, 5, 7], 10).hop_le),
    ("HP04", "kiem_tra_tap([1,2,3],[2,3,4],[4,5,7],5)", "hop_le=false (vuot W)", () -> !kiem_tra_tap([1, 2, 3], [2, 3, 4], [4, 5, 7], 5).hop_le),
    ("HP05", "can_tren(ds_VD01,1,26,0)", "ub=52.625", () -> isapprox(can_tren(sap_theo_ty_le([12, 7, 11, 8, 9], [24, 13, 23, 15, 16]), 1, 26, 0), 52.625; atol=1e-9))
]

for (id, inp, exp, chk) in validators
    @assert chk() "Failed validator/helper case $id"
    println("CATALOG | $id | $inp | $exp | $exp | PASS")
end

println("CATALOG_OK functional_cases=12 invalid_and_helper_cases=16 total_cases=28")
