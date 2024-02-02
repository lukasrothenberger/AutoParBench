; ModuleID = 'prog.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@indexSet = dso_local global [180 x i32] [i32 521, i32 523, i32 525, i32 533, i32 529, i32 531, i32 547, i32 549, i32 551, i32 553, i32 555, i32 557, i32 573, i32 575, i32 577, i32 579, i32 581, i32 583, i32 599, i32 601, i32 603, i32 605, i32 607, i32 609, i32 625, i32 627, i32 629, i32 631, i32 633, i32 635, i32 651, i32 653, i32 655, i32 657, i32 659, i32 661, i32 859, i32 861, i32 863, i32 865, i32 867, i32 869, i32 885, i32 887, i32 889, i32 891, i32 893, i32 895, i32 911, i32 913, i32 915, i32 917, i32 919, i32 921, i32 937, i32 939, i32 941, i32 943, i32 945, i32 947, i32 963, i32 965, i32 967, i32 969, i32 971, i32 973, i32 989, i32 991, i32 993, i32 995, i32 997, i32 999, i32 1197, i32 1199, i32 1201, i32 1203, i32 1205, i32 1207, i32 1223, i32 1225, i32 1227, i32 1229, i32 1231, i32 1233, i32 1249, i32 1251, i32 1253, i32 1255, i32 1257, i32 1259, i32 1275, i32 1277, i32 1279, i32 1281, i32 1283, i32 1285, i32 1301, i32 1303, i32 1305, i32 1307, i32 1309, i32 1311, i32 1327, i32 1329, i32 1331, i32 1333, i32 1335, i32 1337, i32 1535, i32 1537, i32 1539, i32 1541, i32 1543, i32 1545, i32 1561, i32 1563, i32 1565, i32 1567, i32 1569, i32 1571, i32 1587, i32 1589, i32 1591, i32 1593, i32 1595, i32 1597, i32 1613, i32 1615, i32 1617, i32 1619, i32 1621, i32 1623, i32 1639, i32 1641, i32 1643, i32 1645, i32 1647, i32 1649, i32 1665, i32 1667, i32 1669, i32 1671, i32 1673, i32 1675, i32 1873, i32 1875, i32 1877, i32 1879, i32 1881, i32 1883, i32 1899, i32 1901, i32 1903, i32 1905, i32 1907, i32 1909, i32 1925, i32 1927, i32 1929, i32 1931, i32 1933, i32 1935, i32 1951, i32 1953, i32 1955, i32 1957, i32 1959, i32 1961, i32 1977, i32 1979, i32 1981, i32 1983, i32 1985, i32 1987, i32 2003, i32 2005, i32 2007, i32 2009, i32 2011, i32 2013], align 16, !dbg !0
@.str = private unnamed_addr constant [33 x i8] c"Error in malloc(). Aborting ...\0A\00", align 1
@.str.1 = private unnamed_addr constant [25 x i8] c"x1[999]=%f xa2[1285]=%f\0A\00", align 1
@.str.2 = private unnamed_addr constant [7 x i8] c"retval\00", align 1
@.str.3 = private unnamed_addr constant [5 x i8] c"argc\00", align 1
@.str.4 = private unnamed_addr constant [5 x i8] c"argv\00", align 1
@.str.5 = private unnamed_addr constant [5 x i8] c"base\00", align 1
@.str.6 = private unnamed_addr constant [4 x i8] c"xa1\00", align 1
@.str.7 = private unnamed_addr constant [4 x i8] c"xa2\00", align 1
@.str.8 = private unnamed_addr constant [2 x i8] c"i\00", align 1
@.str.9 = private unnamed_addr constant [4 x i8] c"idx\00", align 1
@.str.10 = private unnamed_addr constant [9 x i8] c"indexSet\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !17 {
entry:
  call void @__dp_func_entry(i32 16489, i32 1)
  %retval = alloca i32, align 4
  %0 = ptrtoint i32* %retval to i64
  call void @__dp_alloca(i32 16489, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i64 %0, i64 %0, i64 1)
  %argc.addr = alloca i32, align 4
  %1 = ptrtoint i32* %argc.addr to i64
  call void @__dp_alloca(i32 16489, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i64 %1, i64 %1, i64 1)
  %argv.addr = alloca i8**, align 8
  %2 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_alloca(i32 16489, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.4, i32 0, i32 0), i64 %2, i64 %2, i64 1)
  %base = alloca double*, align 8
  %3 = ptrtoint double** %base to i64
  call void @__dp_alloca(i32 16489, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.5, i32 0, i32 0), i64 %3, i64 %3, i64 1)
  %xa1 = alloca double*, align 8
  %4 = ptrtoint double** %xa1 to i64
  call void @__dp_alloca(i32 16489, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.6, i32 0, i32 0), i64 %4, i64 %4, i64 1)
  %xa2 = alloca double*, align 8
  %5 = ptrtoint double** %xa2 to i64
  call void @__dp_alloca(i32 16489, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0), i64 %5, i64 %5, i64 1)
  %i = alloca i32, align 4
  %6 = ptrtoint i32* %i to i64
  call void @__dp_alloca(i32 16489, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0), i64 %6, i64 %6, i64 1)
  %idx = alloca i32, align 4
  %7 = ptrtoint i32* %idx to i64
  call void @__dp_alloca(i32 16489, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.9, i32 0, i32 0), i64 %7, i64 %7, i64 1)
  %8 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16489, i64 %8, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0))
  store i32 0, i32* %retval, align 4
  %9 = ptrtoint i32* %argc.addr to i64
  call void @__dp_write(i32 16489, i64 %9, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0))
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !23, metadata !DIExpression()), !dbg !24
  %10 = ptrtoint i8*** %argv.addr to i64
  call void @__dp_write(i32 16489, i64 %10, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.4, i32 0, i32 0))
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !25, metadata !DIExpression()), !dbg !26
  call void @llvm.dbg.declare(metadata double** %base, metadata !27, metadata !DIExpression()), !dbg !28
  %call = call noalias i8* @malloc(i64 16208) #4, !dbg !29
  %11 = ptrtoint i8* %call to i64
  call void @__dp_new(i32 16491, i64 %11, i64 %11, i64 16208), !dbg !30
  %12 = bitcast i8* %call to double*, !dbg !30
  %13 = ptrtoint double** %base to i64
  call void @__dp_write(i32 16491, i64 %13, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.5, i32 0, i32 0))
  store double* %12, double** %base, align 8, !dbg !28
  %14 = ptrtoint double** %base to i64
  call void @__dp_read(i32 16492, i64 %14, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.5, i32 0, i32 0))
  %15 = load double*, double** %base, align 8, !dbg !31
  %cmp = icmp eq double* %15, null, !dbg !33
  br i1 %cmp, label %if.then, label %if.end, !dbg !34

if.then:                                          ; preds = %entry
  call void @__dp_call(i32 16494), !dbg !35
  %call1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([33 x i8], [33 x i8]* @.str, i64 0, i64 0)), !dbg !35
  %16 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16495, i64 %16, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0))
  store i32 1, i32* %retval, align 4, !dbg !37
  br label %return, !dbg !37

if.end:                                           ; preds = %entry
  call void @llvm.dbg.declare(metadata double** %xa1, metadata !38, metadata !DIExpression()), !dbg !39
  %17 = ptrtoint double** %base to i64
  call void @__dp_read(i32 16498, i64 %17, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.5, i32 0, i32 0))
  %18 = load double*, double** %base, align 8, !dbg !40
  %19 = ptrtoint double** %xa1 to i64
  call void @__dp_write(i32 16498, i64 %19, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.6, i32 0, i32 0))
  store double* %18, double** %xa1, align 8, !dbg !39
  call void @llvm.dbg.declare(metadata double** %xa2, metadata !41, metadata !DIExpression()), !dbg !42
  %20 = ptrtoint double** %xa1 to i64
  call void @__dp_read(i32 16499, i64 %20, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.6, i32 0, i32 0))
  %21 = load double*, double** %xa1, align 8, !dbg !43
  %add.ptr = getelementptr inbounds double, double* %21, i64 12, !dbg !44
  %22 = ptrtoint double** %xa2 to i64
  call void @__dp_write(i32 16499, i64 %22, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0))
  store double* %add.ptr, double** %xa2, align 8, !dbg !42
  call void @llvm.dbg.declare(metadata i32* %i, metadata !45, metadata !DIExpression()), !dbg !46
  %23 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16503, i64 %23, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  store i32 521, i32* %i, align 4, !dbg !47
  br label %for.cond, !dbg !49

for.cond:                                         ; preds = %for.inc, %if.end
  call void @__dp_loop_entry(i32 16503, i32 0)
  %24 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16503, i64 %24, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  %25 = load i32, i32* %i, align 4, !dbg !50
  %cmp2 = icmp sle i32 %25, 2025, !dbg !52
  br i1 %cmp2, label %for.body, label %for.end, !dbg !53

for.body:                                         ; preds = %for.cond
  call void @incr_loop_counter(i32 2)
  %26 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16505, i64 %26, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  %27 = load i32, i32* %i, align 4, !dbg !54
  %conv = sitofp i32 %27 to double, !dbg !54
  %mul = fmul double 5.000000e-01, %conv, !dbg !56
  %28 = ptrtoint double** %base to i64
  call void @__dp_read(i32 16505, i64 %28, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.5, i32 0, i32 0))
  %29 = load double*, double** %base, align 8, !dbg !57
  %30 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16505, i64 %30, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  %31 = load i32, i32* %i, align 4, !dbg !58
  %idxprom = sext i32 %31 to i64, !dbg !57
  %arrayidx = getelementptr inbounds double, double* %29, i64 %idxprom, !dbg !57
  %32 = ptrtoint double* %arrayidx to i64
  call void @__dp_write(i32 16505, i64 %32, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.5, i32 0, i32 0))
  store double %mul, double* %arrayidx, align 8, !dbg !59
  br label %for.inc, !dbg !60

for.inc:                                          ; preds = %for.body
  %33 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16503, i64 %33, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  %34 = load i32, i32* %i, align 4, !dbg !61
  %inc = add nsw i32 %34, 1, !dbg !61
  %35 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16503, i64 %35, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  store i32 %inc, i32* %i, align 4, !dbg !61
  br label %for.cond, !dbg !62, !llvm.loop !63

for.end:                                          ; preds = %for.cond
  call void @__dp_loop_exit(i32 16508, i32 0)
  %36 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16508, i64 %36, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  store i32 0, i32* %i, align 4, !dbg !65
  br label %for.cond3, !dbg !67

for.cond3:                                        ; preds = %for.inc14, %for.end
  call void @__dp_loop_entry(i32 16508, i32 1)
  %37 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16508, i64 %37, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  %38 = load i32, i32* %i, align 4, !dbg !68
  %cmp4 = icmp slt i32 %38, 180, !dbg !70
  br i1 %cmp4, label %for.body6, label %for.end16, !dbg !71

for.body6:                                        ; preds = %for.cond3
  call void @incr_loop_counter(i32 1)
  call void @llvm.dbg.declare(metadata i32* %idx, metadata !72, metadata !DIExpression()), !dbg !74
  %39 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16510, i64 %39, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  %40 = load i32, i32* %i, align 4, !dbg !75
  %idxprom7 = sext i32 %40 to i64, !dbg !76
  %arrayidx8 = getelementptr inbounds [180 x i32], [180 x i32]* @indexSet, i64 0, i64 %idxprom7, !dbg !76
  %41 = ptrtoint i32* %arrayidx8 to i64
  call void @__dp_read(i32 16510, i64 %41, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.10, i32 0, i32 0))
  %42 = load i32, i32* %arrayidx8, align 4, !dbg !76
  %43 = ptrtoint i32* %idx to i64
  call void @__dp_write(i32 16510, i64 %43, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.9, i32 0, i32 0))
  store i32 %42, i32* %idx, align 4, !dbg !74
  %44 = ptrtoint double** %xa1 to i64
  call void @__dp_read(i32 16511, i64 %44, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.6, i32 0, i32 0))
  %45 = load double*, double** %xa1, align 8, !dbg !77
  %46 = ptrtoint i32* %idx to i64
  call void @__dp_read(i32 16511, i64 %46, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.9, i32 0, i32 0))
  %47 = load i32, i32* %idx, align 4, !dbg !78
  %idxprom9 = sext i32 %47 to i64, !dbg !77
  %arrayidx10 = getelementptr inbounds double, double* %45, i64 %idxprom9, !dbg !77
  %48 = ptrtoint double* %arrayidx10 to i64
  call void @__dp_read(i32 16511, i64 %48, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.6, i32 0, i32 0))
  %49 = load double, double* %arrayidx10, align 8, !dbg !79
  %add = fadd double %49, 1.000000e+00, !dbg !79
  %50 = ptrtoint double* %arrayidx10 to i64
  call void @__dp_write(i32 16511, i64 %50, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.6, i32 0, i32 0))
  store double %add, double* %arrayidx10, align 8, !dbg !79
  %51 = ptrtoint double** %xa2 to i64
  call void @__dp_read(i32 16512, i64 %51, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0))
  %52 = load double*, double** %xa2, align 8, !dbg !80
  %53 = ptrtoint i32* %idx to i64
  call void @__dp_read(i32 16512, i64 %53, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.9, i32 0, i32 0))
  %54 = load i32, i32* %idx, align 4, !dbg !81
  %idxprom11 = sext i32 %54 to i64, !dbg !80
  %arrayidx12 = getelementptr inbounds double, double* %52, i64 %idxprom11, !dbg !80
  %55 = ptrtoint double* %arrayidx12 to i64
  call void @__dp_read(i32 16512, i64 %55, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0))
  %56 = load double, double* %arrayidx12, align 8, !dbg !82
  %add13 = fadd double %56, 3.000000e+00, !dbg !82
  %57 = ptrtoint double* %arrayidx12 to i64
  call void @__dp_write(i32 16512, i64 %57, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0))
  store double %add13, double* %arrayidx12, align 8, !dbg !82
  br label %for.inc14, !dbg !83

for.inc14:                                        ; preds = %for.body6
  %58 = ptrtoint i32* %i to i64
  call void @__dp_read(i32 16508, i64 %58, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  %59 = load i32, i32* %i, align 4, !dbg !84
  %inc15 = add nsw i32 %59, 1, !dbg !84
  %60 = ptrtoint i32* %i to i64
  call void @__dp_write(i32 16508, i64 %60, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i32 0, i32 0))
  store i32 %inc15, i32* %i, align 4, !dbg !84
  br label %for.cond3, !dbg !85, !llvm.loop !86

for.end16:                                        ; preds = %for.cond3
  call void @__dp_loop_exit(i32 16514, i32 1)
  %61 = ptrtoint double** %xa1 to i64
  call void @__dp_read(i32 16514, i64 %61, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.6, i32 0, i32 0))
  %62 = load double*, double** %xa1, align 8, !dbg !88
  %arrayidx17 = getelementptr inbounds double, double* %62, i64 999, !dbg !88
  %63 = ptrtoint double* %arrayidx17 to i64
  call void @__dp_read(i32 16514, i64 %63, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.6, i32 0, i32 0))
  %64 = load double, double* %arrayidx17, align 8, !dbg !88
  %65 = ptrtoint double** %xa2 to i64
  call void @__dp_read(i32 16514, i64 %65, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0))
  %66 = load double*, double** %xa2, align 8, !dbg !89
  %arrayidx18 = getelementptr inbounds double, double* %66, i64 1285, !dbg !89
  %67 = ptrtoint double* %arrayidx18 to i64
  call void @__dp_read(i32 16514, i64 %67, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0))
  %68 = load double, double* %arrayidx18, align 8, !dbg !89
  call void @__dp_call(i32 16514), !dbg !90
  %call19 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str.1, i64 0, i64 0), double %64, double %68), !dbg !90
  %69 = ptrtoint double** %base to i64
  call void @__dp_read(i32 16515, i64 %69, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.5, i32 0, i32 0))
  %70 = load double*, double** %base, align 8, !dbg !91
  %71 = bitcast double* %70 to i8*, !dbg !91
  call void @free(i8* %71) #4, !dbg !92
  %72 = ptrtoint i8* %71 to i64
  call void @__dp_delete(i32 16515, i64 %72), !dbg !93
  %73 = ptrtoint i32* %retval to i64
  call void @__dp_write(i32 16516, i64 %73, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0))
  store i32 0, i32* %retval, align 4, !dbg !93
  br label %return, !dbg !93

return:                                           ; preds = %for.end16, %if.then
  %74 = ptrtoint i32* %retval to i64
  call void @__dp_read(i32 16517, i64 %74, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0))
  %75 = load i32, i32* %retval, align 4, !dbg !94
  call void @__dp_finalize(i32 16517), !dbg !94
  call void @loop_counter_output(), !dbg !94
  ret i32 %75, !dbg !94
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare dso_local noalias i8* @malloc(i64) #2

declare dso_local i32 @printf(i8*, ...) #3

; Function Attrs: nounwind
declare dso_local void @free(i8*) #2

declare void @__dp_init(i32, i32, i32)

declare void @__dp_finalize(i32)

declare void @__dp_read(i32, i64, i8*)

declare void @__dp_write(i32, i64, i8*)

declare void @__dp_alloca(i32, i8*, i64, i64, i64)

declare void @__dp_new(i32, i64, i64, i64)

declare void @__dp_delete(i32, i64)

declare void @__dp_call(i32)

declare void @__dp_func_entry(i32, i32)

declare void @__dp_func_exit(i32, i32)

declare void @__dp_loop_entry(i32, i32)

declare void @__dp_loop_exit(i32, i32)

declare void @__dp_report_bb(i32)

declare void @__dp_report_bb_pair(i32, i32)

declare void @incr_loop_counter(i32)

declare void @loop_counter_output()

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!13}
!llvm.module.flags = !{!14, !15, !16}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "indexSet", scope: !2, file: !3, line: 68, type: !9, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 11.1.0-6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !5, globals: !8, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "DRB007-indirectaccess3-orig-yes.c", directory: "/home/lukas/git/AutoParBench-Vanilla/benchmarks/DiscoPoP/dataracebench/dp_temp/.discopop")
!4 = !{}
!5 = !{!6}
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!8 = !{!0}
!9 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 5760, elements: !11)
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !{!12}
!12 = !DISubrange(count: 180)
!13 = !{!"Ubuntu clang version 11.1.0-6"}
!14 = !{i32 7, !"Dwarf Version", i32 4}
!15 = !{i32 2, !"Debug Info Version", i32 3}
!16 = !{i32 1, !"wchar_size", i32 4}
!17 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 105, type: !18, scopeLine: 106, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!18 = !DISubroutineType(types: !19)
!19 = !{!10, !10, !20}
!20 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !21, size: 64)
!21 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !22, size: 64)
!22 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!23 = !DILocalVariable(name: "argc", arg: 1, scope: !17, file: !3, line: 105, type: !10)
!24 = !DILocation(line: 105, column: 15, scope: !17)
!25 = !DILocalVariable(name: "argv", arg: 2, scope: !17, file: !3, line: 105, type: !20)
!26 = !DILocation(line: 105, column: 27, scope: !17)
!27 = !DILocalVariable(name: "base", scope: !17, file: !3, line: 107, type: !6)
!28 = !DILocation(line: 107, column: 12, scope: !17)
!29 = !DILocation(line: 107, column: 29, scope: !17)
!30 = !DILocation(line: 107, column: 19, scope: !17)
!31 = !DILocation(line: 108, column: 7, scope: !32)
!32 = distinct !DILexicalBlock(scope: !17, file: !3, line: 108, column: 7)
!33 = !DILocation(line: 108, column: 12, scope: !32)
!34 = !DILocation(line: 108, column: 7, scope: !17)
!35 = !DILocation(line: 110, column: 5, scope: !36)
!36 = distinct !DILexicalBlock(scope: !32, file: !3, line: 109, column: 3)
!37 = !DILocation(line: 111, column: 5, scope: !36)
!38 = !DILocalVariable(name: "xa1", scope: !17, file: !3, line: 114, type: !6)
!39 = !DILocation(line: 114, column: 12, scope: !17)
!40 = !DILocation(line: 114, column: 18, scope: !17)
!41 = !DILocalVariable(name: "xa2", scope: !17, file: !3, line: 115, type: !6)
!42 = !DILocation(line: 115, column: 12, scope: !17)
!43 = !DILocation(line: 115, column: 18, scope: !17)
!44 = !DILocation(line: 115, column: 22, scope: !17)
!45 = !DILocalVariable(name: "i", scope: !17, file: !3, line: 116, type: !10)
!46 = !DILocation(line: 116, column: 7, scope: !17)
!47 = !DILocation(line: 119, column: 10, scope: !48)
!48 = distinct !DILexicalBlock(scope: !17, file: !3, line: 119, column: 3)
!49 = !DILocation(line: 119, column: 8, scope: !48)
!50 = !DILocation(line: 119, column: 16, scope: !51)
!51 = distinct !DILexicalBlock(scope: !48, file: !3, line: 119, column: 3)
!52 = !DILocation(line: 119, column: 17, scope: !51)
!53 = !DILocation(line: 119, column: 3, scope: !48)
!54 = !DILocation(line: 121, column: 17, scope: !55)
!55 = distinct !DILexicalBlock(scope: !51, file: !3, line: 120, column: 3)
!56 = !DILocation(line: 121, column: 16, scope: !55)
!57 = !DILocation(line: 121, column: 5, scope: !55)
!58 = !DILocation(line: 121, column: 10, scope: !55)
!59 = !DILocation(line: 121, column: 12, scope: !55)
!60 = !DILocation(line: 122, column: 3, scope: !55)
!61 = !DILocation(line: 119, column: 26, scope: !51)
!62 = !DILocation(line: 119, column: 3, scope: !51)
!63 = distinct !{!63, !53, !64}
!64 = !DILocation(line: 122, column: 3, scope: !48)
!65 = !DILocation(line: 124, column: 10, scope: !66)
!66 = distinct !DILexicalBlock(scope: !17, file: !3, line: 124, column: 3)
!67 = !DILocation(line: 124, column: 8, scope: !66)
!68 = !DILocation(line: 124, column: 14, scope: !69)
!69 = distinct !DILexicalBlock(scope: !66, file: !3, line: 124, column: 3)
!70 = !DILocation(line: 124, column: 15, scope: !69)
!71 = !DILocation(line: 124, column: 3, scope: !66)
!72 = !DILocalVariable(name: "idx", scope: !73, file: !3, line: 126, type: !10)
!73 = distinct !DILexicalBlock(scope: !69, file: !3, line: 125, column: 3)
!74 = !DILocation(line: 126, column: 9, scope: !73)
!75 = !DILocation(line: 126, column: 24, scope: !73)
!76 = !DILocation(line: 126, column: 15, scope: !73)
!77 = !DILocation(line: 127, column: 5, scope: !73)
!78 = !DILocation(line: 127, column: 9, scope: !73)
!79 = !DILocation(line: 127, column: 13, scope: !73)
!80 = !DILocation(line: 128, column: 5, scope: !73)
!81 = !DILocation(line: 128, column: 9, scope: !73)
!82 = !DILocation(line: 128, column: 13, scope: !73)
!83 = !DILocation(line: 129, column: 3, scope: !73)
!84 = !DILocation(line: 124, column: 20, scope: !69)
!85 = !DILocation(line: 124, column: 3, scope: !69)
!86 = distinct !{!86, !71, !87}
!87 = !DILocation(line: 129, column: 3, scope: !66)
!88 = !DILocation(line: 130, column: 39, scope: !17)
!89 = !DILocation(line: 130, column: 49, scope: !17)
!90 = !DILocation(line: 130, column: 3, scope: !17)
!91 = !DILocation(line: 131, column: 9, scope: !17)
!92 = !DILocation(line: 131, column: 3, scope: !17)
!93 = !DILocation(line: 132, column: 3, scope: !17)
!94 = !DILocation(line: 133, column: 1, scope: !17)
