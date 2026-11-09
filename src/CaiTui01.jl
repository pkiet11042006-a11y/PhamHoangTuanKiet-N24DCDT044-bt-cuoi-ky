# Module CaiTui01 - Đề tài DT040: Chọn đồ vật bằng nhánh và cận cho cái túi 0/1
# Sinh viên: Phạm Hoàng Tuấn Kiệt - MSSV: N24DCDT044 - Lớp: D24CQDT01-N
# Học phần: Cấu trúc dữ liệu và giải thuật (INT13185 - Nhóm 03)
# Căn cứ giáo trình: Chương 3, Bài 3.3 Cái túi bằng nhánh và cận;
# Bài tập chương 3, câu 30; trang in 79, 86; trang PDF 91, 98.

module CaiTui01

export DoVat, kiem_tra_dau_vao, sap_theo_ty_le, can_tren, thu_cai_tui, kiem_tra_tap, giai_cai_tui

"""
    DoVat

Cấu trúc lưu thông tin một đồ vật sau khi chuẩn hóa:
- `id::Int`: chỉ số gốc (1..n) trong dữ liệu đầu vào.
- `w::Int`: trọng lượng nguyên dương (1 <= w <= 100).
- `v::Int`: giá trị nguyên không âm (0 <= v <= 1000).
- `ty_le::Float64`: tỷ lệ đơn vị `v / w` dùng để sắp thứ tự ưu tiên tham lam phân số.
"""
struct DoVat
    id::Int
    w::Int
    v::Int
    ty_le::Float64
end

"""
    kiem_tra_dau_vao(w, v, W)

Kiểm tra hợp đồng đầu vào của bài toán cái túi 0/1 theo phiếu giao đề tài DT040:
- `w`, `v` là hai mảng một chiều cùng độ dài `n`, với `1 <= n <= 18`.
- Mọi phần tử `w[i]` là số nguyên dương: `1 <= w[i] <= 100`.
- Mọi phần tử `v[i]` là số nguyên không âm: `0 <= v[i] <= 1000`.
- Sức chứa `W` là số nguyên trong miền `0 <= W <= 500`.
Ném `ArgumentError` với thông điệp rõ ràng nếu bất kỳ điều kiện nào bị vi phạm.
"""
function kiem_tra_dau_vao(w, v, W)
    (w isa AbstractVector && v isa AbstractVector) ||
        throw(ArgumentError("w va v phai la mang mot chieu"))
    n = length(w)
    length(v) == n ||
        throw(ArgumentError("hai mang w va v phai co cung do dai"))
    1 <= n <= 18 ||
        throw(ArgumentError("so do vat n phai nam trong mien 1..18"))
    (W isa Integer && !(W isa Bool)) ||
        throw(ArgumentError("suc chua W phai la so nguyen"))
    0 <= W <= 500 ||
        throw(ArgumentError("suc chua W phai nam trong mien 0..500"))

    for i in 1:n
        wi = w[i]
        vi = v[i]
        (wi isa Integer && !(wi isa Bool)) ||
            throw(ArgumentError("trong luong w[$i] phai la so nguyen"))
        (vi isa Integer && !(vi isa Bool)) ||
            throw(ArgumentError("gia tri v[$i] phai la so nguyen"))
        1 <= wi <= 100 ||
            throw(ArgumentError("trong luong w[$i] phai nam trong mien 1..100"))
        0 <= vi <= 1000 ||
            throw(ArgumentError("gia tri v[$i] phai nam trong mien 0..1000"))
    end
    return true
end

"""
    sap_theo_ty_le(w, v) -> Vector{DoVat}

Bước 1 trên phiếu: Lưu mỗi đồ vật cùng ID gốc (`1..n`), trọng lượng `w[i]`, giá trị `v[i]`
và sắp xếp theo tỷ lệ `v[i]/w[i]` giảm dần mà không làm mất ID ban đầu.
Khi hai đồ vật có cùng tỷ lệ (`v[i]*w[j] == v[j]*w[i]`), giữ nguyên thứ tự ID gốc tăng dần
để đảm bảo tính tất định (deterministic).
"""
function sap_theo_ty_le(w, v)
    kiem_tra_dau_vao(w, v, 0)
    n = length(w)
    ds = Vector{DoVat}(undef, n)
    for i in 1:n
        wi = Int(w[i])
        vi = Int(v[i])
        ds[i] = DoVat(i, wi, vi, vi / wi)
    end
    # So sánh chính xác bằng tích chéo a.v * b.w và b.v * a.w để tránh sai số dấu phẩy động,
    # nếu bằng nhau thì ưu tiên ID gốc nhỏ hơn đứng trước.
    sort!(ds, lt = (a, b) -> (a.v * b.w != b.v * a.w ? a.v * b.w > b.v * a.w : a.id < b.id))
    return ds
end

"""
    can_tren(ds::Vector{DoVat}, i::Integer, suc_con::Integer, gia_tri::Integer) -> Float64
    can_tren(i::Integer, suc_con::Integer, gia_tri::Integer, ds::Vector{DoVat}) -> Float64

Bước 2 trên phiếu: Tính cận trên kiểu tham lam phân số tại vị trí đang xét `i` (trong danh sách
`ds` đã sắp theo tỷ lệ giảm dần), với sức chứa còn lại `suc_con` và tổng giá trị hiện có `gia_tri`.
Điền phần túi còn lại bằng các đồ vật từ vị trí `i` đến `n`; nếu đồ vật đầu tiên không vừa nguyên vẹn,
cho phép lấy một phần (`suc_con / ds[j].w`) của đồ vật đó. Phần lẻ chỉ dùng để ước lượng cận trên,
không bao giờ xuất hiện trong nghiệm 0/1 cuối cùng.
"""
function can_tren(ds::Vector{DoVat}, i::Integer, suc_con::Integer, gia_tri::Integer)
    suc_con >= 0 || throw(ArgumentError("suc_con phai khong am"))
    ub = Float64(gia_tri)
    con = Int(suc_con)
    n = length(ds)
    for j in Int(i):n
        con <= 0 && break
        if ds[j].w <= con
            con -= ds[j].w
            ub += ds[j].v
        else
            ub += ds[j].v * (con / ds[j].w)
            con = 0
            break
        end
    end
    return ub
end

can_tren(i::Integer, suc_con::Integer, gia_tri::Integer, ds::Vector{DoVat}) =
    can_tren(ds, i, suc_con, gia_tri)

"""
    thu_cai_tui(ds::Vector{DoVat}, W::Integer; dung_can::Bool=true)

Bước 3 & 4 trên phiếu: Duyệt cây chọn/bỏ trên danh sách đồ vật `ds` đã sắp tỷ lệ giảm dần.
Hàm nội bộ `thu_cai_tui(i)` xét đồ vật ở vị trí `i`:
- Tính cận trên phân số tại nút hiện tại; nếu `dung_can=true` và `can_tren <= gia_tri_tot_nhat`,
  cắt tỉa nhánh ngay (tăng `so_cat_can`).
- Nếu `i > n` (nút lá), kiểm tra và cập nhật kỷ lục nếu tốt hơn.
- Nhánh 1 (chọn `ds[i]`): nếu `trong_hien_tai + ds[i].w <= W`, thêm đồ vật, cập nhật kỷ lục nếu
  đạt giá trị lớn hơn kỷ lục hiện tại, rồi gọi đệ quy `thu_cai_tui(i + 1)` và hoàn tác (backtrack).
- Nhánh 2 (bỏ `ds[i]`): giữ nguyên trọng lượng và giá trị, gọi đệ quy `thu_cai_tui(i + 1)`.
Trả về NamedTuple gồm: `gia_tri`, `chon` (danh sách ID gốc tăng dần), `trong_luong`,
`so_nut` (số nút đã thăm trên cây tìm kiếm), `so_cat_can` (số lần cắt nhánh nhờ cận trên).
"""
function thu_cai_tui(ds::Vector{DoVat}, W::Integer; dung_can::Bool=true)
    0 <= W <= 500 || throw(ArgumentError("suc chua W phai nam trong mien 0..500"))
    n = length(ds)
    1 <= n <= 18 || throw(ArgumentError("so do vat n phai nam trong mien 1..18"))

    chon_hien_tai = zeros(Bool, n)
    chon_tot_nhat = zeros(Bool, n)
    gia_tri_hien_tai = 0
    trong_hien_tai = 0
    gia_tri_tot_nhat = 0
    trong_tot_nhat = 0
    so_nut = 0
    so_cat_can = 0

    function thu_cai_tui(i::Int)
        so_nut += 1
        if gia_tri_hien_tai > gia_tri_tot_nhat
            gia_tri_tot_nhat = gia_tri_hien_tai
            trong_tot_nhat = trong_hien_tai
            copyto!(chon_tot_nhat, chon_hien_tai)
        end
        i > n && return nothing

        if dung_can
            ub = can_tren(ds, i, W - trong_hien_tai, gia_tri_hien_tai)
            # Cận trên phân số là giới hạn trên thực sự. Vì v[i] đều nguyên nên mọi nghiệm nguyên
            # trong nhánh con đều có tổng giá trị <= floor(ub + 1e-9). Nếu ub <= gia_tri_tot_nhat
            # thì nhánh này chắc chắn không thể tạo ra nghiệm nguyên tốt hơn gia_tri_tot_nhat.
            if ub <= gia_tri_tot_nhat + 1e-9
                so_cat_can += 1
                return nothing
            end
        end

        # Nhánh 1: Thử chọn đồ vật thứ i nếu còn đủ chỗ trong túi
        if trong_hien_tai + ds[i].w <= W
            chon_hien_tai[i] = true
            trong_hien_tai += ds[i].w
            gia_tri_hien_tai += ds[i].v
            if gia_tri_hien_tai > gia_tri_tot_nhat
                gia_tri_tot_nhat = gia_tri_hien_tai
                trong_tot_nhat = trong_hien_tai
                copyto!(chon_tot_nhat, chon_hien_tai)
            end
            thu_cai_tui(i + 1)
            gia_tri_hien_tai -= ds[i].v
            trong_hien_tai -= ds[i].w
            chon_hien_tai[i] = false
        end

        # Nhánh 2: Thử bỏ đồ vật thứ i
        thu_cai_tui(i + 1)
        return nothing
    end

    thu_cai_tui(1)

    # Khôi phục danh sách ID gốc được chọn và sắp theo ID tăng dần đúng hợp đồng đầu ra
    chon_id = Int[ds[i].id for i in 1:n if chon_tot_nhat[i]]
    sort!(chon_id)

    return (; gia_tri = gia_tri_tot_nhat,
              chon = chon_id,
              trong_luong = trong_tot_nhat,
              so_nut,
              so_cat_can)
end

"""
    kiem_tra_tap(chon, w, v, W) -> NamedTuple{(:hop_le, :trong_luong, :gia_tri, :ly_do)}

Bước 5 trên phiếu: Kiểm tra độc lập một tập ID đồ vật `chon` so với dữ liệu gốc `w`, `v`, `W`:
- Danh sách `chon` chỉ gồm các số nguyên phân biệt trong miền `1..n` và được sắp tăng dần nghiêm ngặt
  (mỗi đồ vật chỉ chọn tối đa 1 lần — tính chất 0/1).
- Tự cộng lại tổng trọng lượng `sum(w[id])` và tổng giá trị `sum(v[id])`.
- Tổng trọng lượng không được vượt quá sức chứa `W`.
"""
function kiem_tra_tap(chon, w, v, W)
    kiem_tra_dau_vao(w, v, W)
    chon isa AbstractVector ||
        return (; hop_le = false, trong_luong = -1, gia_tri = -1, ly_do = "chon phai la mang")
    n = length(w)
    tong_w = 0
    tong_v = 0
    truoc = 0
    for idx in chon
        (idx isa Integer && !(idx isa Bool)) ||
            return (; hop_le = false, trong_luong = -1, gia_tri = -1, ly_do = "ID khong nguyen")
        id = Int(idx)
        1 <= id <= n ||
            return (; hop_le = false, trong_luong = -1, gia_tri = -1, ly_do = "ID nam ngoai 1..n")
        id > truoc ||
            return (; hop_le = false, trong_luong = -1, gia_tri = -1, ly_do = "ID khong tang nghiem ngat hoac bi trung")
        truoc = id
        tong_w += Int(w[id])
        tong_v += Int(v[id])
    end
    if tong_w > W
        return (; hop_le = false, trong_luong = tong_w, gia_tri = tong_v, ly_do = "vuot suc chua W")
    end
    return (; hop_le = true, trong_luong = tong_w, gia_tri = tong_v, ly_do = "OK")
end

"""
    giai_cai_tui(w, v, W; so_sanh_khong_can::Bool=true)

Hàm chính ghép toàn bộ quy trình giải bài toán cái túi 0/1 bằng nhánh và cận:
1. Kiểm tra dữ liệu đầu vào `kiem_tra_dau_vao(w, v, W)`.
2. Sắp xếp đồ vật theo tỷ lệ `v[i]/w[i]` giảm dần nhưng giữ nguyên ID gốc `sap_theo_ty_le(w, v)`.
3. Chạy nhánh và cận `thu_cai_tui(ds, W; dung_can=true)`.
4. Nếu `so_sanh_khong_can=true`, chạy thêm bản quay lui không dùng cận (`dung_can=false`)
   để đối chiếu số nút đã xét và xác nhận cả hai cho cùng giá trị tối ưu.
5. Tự kiểm tra tập nghiệm xuất ra bằng `kiem_tra_tap(chon, w, v, W)`.
"""
function giai_cai_tui(w, v, W; so_sanh_khong_can::Bool=true)
    kiem_tra_dau_vao(w, v, W)
    ds = sap_theo_ty_le(w, v)
    can_goc = can_tren(ds, 1, Int(W), 0)
    kq_co_can = thu_cai_tui(ds, Int(W); dung_can=true)
    kt = kiem_tra_tap(kq_co_can.chon, w, v, W)
    @assert kt.hop_le "Tap chon khong hop le: $(kt.ly_do)"
    @assert kt.trong_luong == kq_co_can.trong_luong
    @assert kt.gia_tri == kq_co_can.gia_tri

    so_nut_khong_can = -1
    if so_sanh_khong_can
        kq_khong_can = thu_cai_tui(ds, Int(W); dung_can=false)
        @assert kq_khong_can.gia_tri == kq_co_can.gia_tri
        so_nut_khong_can = kq_khong_can.so_nut
    end

    return (; ds,
              can_goc,
              gia_tri = kq_co_can.gia_tri,
              chon = kq_co_can.chon,
              trong_luong = kq_co_can.trong_luong,
              so_nut = kq_co_can.so_nut,
              so_cat_can = kq_co_can.so_cat_can,
              so_nut_khong_can,
              kiem_tra = kt.hop_le)
end

end # module CaiTui01
