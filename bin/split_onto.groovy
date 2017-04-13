
String families= new File(args[0]).text
int splitby=args[1].toInteger()
println splitby

def ar=families.split("(?=\n\\<)")
//print ar
def ref_map=[:]
def test_map=[:]
def item_ar=""
String prefix=""
for (item in ar) {

    if (item.contains('@prefix')){
        prefix+=item
    }
    if (item.contains("refere")) {
        //print "$item\n"
        item_ar=item.split('-refere')
        ref_map[item_ar[0]]=item
        //print item_ar[0]
        //print ref_map[item_ar[0]]

    }
    if (item.contains("test")) {
        //print "$item\n"
        item_ar=item.split('-test')
        test_map[item_ar[0]]=item
        //print item_ar[0]
        //print test_map[item_ar[0]]
    }
}

int count=0 
def countf=0
f = new File("query$countf")
f << prefix
def f = new File("query0")
for ( i in test_map)
{   
    if( splitby == count ){
        count=0;
        countf++
        f = new File("query${countf}.ttl")
        f << prefix
    }
  
    //println i.value
    //println ref_map[i.key]

    f << i.value
    f << ref_map[i.key]
    count++;

}
