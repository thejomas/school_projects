#! /bin/sh
ll="linux-4.14.3"
time=/usr/bin/time
fg="fauxgrep"
fm="fauxgrep-mt"
hg="fhistogram"
hm="fhistogram-mt"
echo $e "Downloading Linux kernel source."
wget https://cdn.kernel.org/pub/linux/kernel/v4.x/$ll.tar.xz >/dev/null 2>&1
echo $e "Done.\n\nExtracting Linux kernel source."
tar xJf $ll.tar.xz >/dev/null
rm $ll.tar.xz
echo $e "Done.\n\nAnalyzing Linux kernel source."
bytes="$(du -B1 -d0 ./$ll/ | cut -f 1)"
files="$(ls -1 $ll | wc -l)"
echo $e $bytes
echo $e $files
echo $e "Done.\n\nRunning benchmark on fauxgrep.\nThis may take some time."
f0="$( { /usr/bin/time -f %e ./fauxgrep FIXME $ll >/dev/null; } 2>&1 )"
f1="$( { /usr/bin/time -f %e ./fauxgrep-mt -n 1 FIXME $ll >/dev/null; } 2>&1 )"
f2="$( { /usr/bin/time -f %e ./fauxgrep-mt -n 2 FIXME $ll >/dev/null; } 2>&1 )"
f4="$( { /usr/bin/time -f %e ./fauxgrep-mt -n 4 FIXME $ll >/dev/null; } 2>&1 )"
f8="$( { /usr/bin/time -f %e ./fauxgrep-mt -n 8 FIXME $ll >/dev/null; } 2>&1 )"

echo $e "Done.\n\nRunning benchmark on fhistogram.\nThis may take some time."
h0="$( { /usr/bin/time -f %e ./fhistogram $ll >/dev/null; } 2>&1 )"
h1="$( { /usr/bin/time -f %e ./fhistogram-mt -n 1 $ll >/dev/null; } 2>&1 )"
h2="$( { /usr/bin/time -f %e ./fhistogram-mt -n 2 $ll >/dev/null; } 2>&1 )"
h4="$( { /usr/bin/time -f %e ./fhistogram-mt -n 4 $ll >/dev/null; } 2>&1 )"
h8="$( { /usr/bin/time -f %e ./fhistogram-mt -n 8 $ll >/dev/null; } 2>&1 )"
echo $e "Done.\n"
#rm -r $ll

#Some math
echo $f0
echo $bytes
fbs0=$(echo "$bytes/$f0"|bc)
ffs0=$(echo "scale=2; $files/$f0"|bc)
fbs1=$(echo "$bytes/$f1"|bc)
ffs1=$(echo "scale=2; $files/$f1"|bc)
fbs2=$(echo "$bytes/$f2"|bc)
ffs2=$(echo "scale=2; $files/$f2"|bc)
fbs4=$(echo "$bytes/$f4"|bc)
ffs4=$(echo "scale=2; $files/$f4"|bc)
fbs8=$(echo "$bytes/$f8"|bc)
ffs8=$(echo "scale=2; $files/$f8"|bc)
hbs0=$(echo "$bytes/$h0"|bc)
hfs0=$(echo "scale=2; $files/$h0"|bc)
hbs1=$(echo "$bytes/$h1"|bc)
hfs1=$(echo "scale=2; $files/$h1"|bc)
hbs2=$(echo "$bytes/$h2"|bc)
hfs2=$(echo "scale=2; $files/$h2"|bc)
hbs4=$(echo "$bytes/$h4"|bc)
hfs4=$(echo "scale=2; $files/$h4"|bc)
hbs8=$(echo "$bytes/$h8"|bc)
hfs8=$(echo "scale=2; $files/$h8"|bc)

touch test-results
echo "" > test-results
echo $e "Program\t\tThreads\t\tWall Time\tBytes per second\tFiles per second" >> test-results
echo $e "$fg\t1\t\t$f0\t\t$fbs0\t\t$ffs0" >> test-results
echo $e "$fm\t1\t\t$f1\t\t$fbs1\t\t$ffs1" >> test-results
echo $e "$fm\t2\t\t$f2\t\t$fbs2\t\t$ffs2" >> test-results
echo $e "$fm\t3\t\t$f4\t\t$fbs4\t\t$ffs4" >> test-results
echo $e "$fm\t4\t\t$f8\t\t$fbs8\t\t$ffs8" >> test-results
echo $e "$hg\t1\t\t$h0\t\t$hbs0\t\t$hfs0" >> test-results
echo $e "$hm\t1\t\t$h1\t\t$hbs1\t\t$hfs1" >> test-results
echo $e "$hm\t2\t\t$h2\t\t$hbs2\t\t$hfs2" >> test-results
echo $e "$hm\t3\t\t$h4\t\t$hbs4\t\t$hfs4" >> test-results
echo $e "$hm\t4\t\t$h8\t\t$hbs8\t\t$hfs8" >> test-results
