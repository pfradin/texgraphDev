var container = document.getElementById('mycanvas');
var containerGUI = document.getElementById('panel');
document.body.appendChild( container );
document.body.appendChild( containerGUI );

var renderer = new THREE.WebGLRenderer({ antialias: true });
renderer.setSize(container.clientWidth, container.clientHeight);
container.appendChild(renderer.domElement);

var scene = new THREE.Scene();
scene.background = new THREE.Color('rgb(128,128,128)' );

var camera = new THREE.PerspectiveCamera( 45, container.clientWidth/container.clientHeight, 0.1, 1000 );            
scene.add(camera);

var light = new THREE.AmbientLight( 'rgb(212, 235, 255)',0.5 ); // soft white light
scene.add( light );
var spotcolor = "rgb(120,120,120)";
var intens = 0.4;
var light2 = new THREE.SpotLight(spotcolor,intens);
light2.position.set(20,5,25);
scene.add(light2);
var light2 = new THREE.SpotLight(spotcolor,intens);
light2.position.set(-20,-5,-25);
scene.add(light2);

var light3 = new THREE.SpotLight(spotcolor,intens);
light3.position.set(0,50,0);
scene.add(light3);
var light3 = new THREE.SpotLight(spotcolor,intens);
light3.position.set(0,-50,0);
scene.add(light3);

var light3 = new THREE.SpotLight(spotcolor,intens);
light3.position.set(0,0,20);
scene.add(light3);
var light3 = new THREE.SpotLight(spotcolor,intens);
light3.position.set(0,0,-20);
scene.add(light3);

var group = new THREE.Object3D();            
scene.add(group);
var objet3D = [];

window.addEventListener( 'resize', onWindowResize, false );

var rotation = false;

function init(){ //création de la scène pour le type de solide souhaité
    camera.position.z = 2.5;
    camera.position.x = 2;
    camera.position.y = 0.5;
 //scene 3D   
    for (var i=0; i<MODEL.length; i++){//Model est une liste d'objets
        var object = MODEL[i];
        if (object["type"]=="line"){
            addLines(i)
        }
        else if (object["type"]=="dot"){
            addDots(i)
        }
        else{
            addFaces(i)
        };
    };
};//fin init

function addFaces(i){
    var object = MODEL[i];
    var flat = (object["type"]=="flat");
    var couleur = new THREE.Color(object["color"][0],object["color"][1],object["color"][2]);    
    var V = object["vertex"]; //liste [x,y,z,x,y,z,...])
    var indices = object["index"];// 3 index = une facette
    var geometry = new THREE.BufferGeometry();    
    geometry.addAttribute( 'position', new THREE.Float32BufferAttribute( V, 3 ) );
    geometry.setIndex(new THREE.Uint16BufferAttribute(indices,1));
    geometry.computeBoundingSphere();          
    if (flat){
        geometry.computeFaceNormals();
    }
    else{
        geometry.computeVertexNormals();
    };
    var shn = 20;
    if (flat){
        shn = 30
    };
    var back = THREE.DoubleSide;
    if (object["backcull"]==1){
        back = THREE.FrontSide
    };
    material =  new THREE.MeshPhongMaterial( {
        color : couleur,
        emissive : 'black',
        transparent: (object["opacity"]!=1), opacity: object["opacity"],
        specular : "white",
        shininess : shn,
        flatShading : flat,
        side : back,
        } );
    var mesh = new THREE.Mesh( geometry, material );
    objet3D.push(new THREE.Object3D());
    group.add(objet3D[objet3D.length-1]);
    objet3D[objet3D.length-1].add(mesh);
};//fin addFaces

function addTubes(i){
    var object = MODEL[i];
    var couleur = new THREE.Color(object["color"][0],object["color"][1],object["color"][2]);    
    var vertex = object["vertex"]; //liste de [x,y,z])    
    var materialLine = new THREE.MeshPhongMaterial( {
            color : couleur,
            emissive : 'black',
            specular : "white",
            shininess : 10,
            flatShading : false,
            } );
    aretes = new THREE.Object3D();
    var L = object["index"];
    for ( var i = 0; i < L.length; i ++ ) {
        for (var j = 0; j<L[i].length-1; j++) {
            var V = [];
            V.push(new THREE.Vector3(vertex[3*L[i][j]], vertex[3*L[i][j]+1], vertex[3*L[i][j]+2]));
            V.push(new THREE.Vector3(vertex[3*L[i][j+1]], vertex[3*L[i][j+1]+1], vertex[3*L[i][j+1]+2]));
            var mesh = cylinderMesh( V[0].clone(), V[1].clone(),materialLine);
            aretes.add(mesh);
        };
    };    
    objet3D.push(aretes);
    group.add(objet3D[objet3D.length-1]);
    //objet3D[objet3D.length-1].add(mesh);
}; //fin addTubes

function addLines(i){
    var object = MODEL[i];
    var couleur = new THREE.Color(object["color"][0],object["color"][1],object["color"][2]);    
    var vertex = object["vertex"]; //liste de [x,y,z])    
    aretes = new THREE.Object3D();
    var dash = (object["dash"]!=0);
    if (!dash){
        var materialLine = new THREE.LineBasicMaterial( {
            color : couleur,
            linewidth: object["thick"], // in pixels
            } ); 
    }
    else{
        var materialLine = new THREE.LineDashedMaterial( {
        color: couleur,
        linewidth: object["thick"], // in pixels
        scale: 1,
        dashSize: 0.05,
        gapSize: 0.025,
        } );
    };
    var L = object["index"];
    for ( var i = 0; i < L.length; i ++ ) {
        var V = [];
        for (var j = 0; j<L[i].length; j++) {
            V.push(vertex[3*L[i][j]], vertex[3*L[i][j]+1], vertex[3*L[i][j]+2])
        };
        var geometry = new THREE.BufferGeometry();
        geometry.addAttribute( 'position', new THREE.Float32BufferAttribute( V, 3 ) );
        geometry.computeBoundingSphere();      
        line = new THREE.Line( geometry, materialLine );
        if (dash){
            line.computeLineDistances();
            };
        aretes.add(line);
    };    
    objet3D.push(aretes);
    group.add(objet3D[objet3D.length-1]);
}; //fin addLines

function addDots(i){
    var object = MODEL[i];
    var couleur = new THREE.Color(object["color"][0],object["color"][1],object["color"][2]);    
    var vertex = object["vertex"]; //liste de [x,y,z])    
    dots = new THREE.Object3D();
    var materialDot = new THREE.MeshStandardMaterial( {
            color: couleur,
            emissive : 'black',
            metalness: 0.8,
            roughness: 0.5,
        } );
    var geometry = new THREE.SphereBufferGeometry( 0.0325*object["thick"]/2, 10, 10 );
    for ( var i = 0; i < vertex.length/3; i ++ ) {//une petite sphère par sommet
        var mesh = new THREE.Mesh( geometry, materialDot );
        mesh.position.set(vertex[3*i],vertex[3*i+1],vertex[3*i+2]);
        dots.add( mesh );
    };        
    objet3D.push(dots);
    group.add(objet3D[objet3D.length-1]);
}; //fin addDots

var controls = new THREE.TrackballControls(camera, renderer.domElement);
controls.enableDamping = true;
controls.dampingFactor = 0.25;
controls.enableZoom = true;

//création du menu avec DAT.GUI  
function createPanel() {
    dat.GUI.TEXT_CLOSED='Fermer contrôles';
    dat.GUI.TEXT_OPEN='Ouvrir contrôles';
    
    var panel = new dat.GUI( {width: 150 } );
    containerGUI.appendChild( panel.domElement );
    var folder1 = panel.addFolder( 'Voir :' );
    var settings = {'rotation':false };
    folder1.add( settings, 'rotation' ).onChange( showRotation );
    for (i=0; i<objet3D.length; i++){
        settings['objet'+(i+1)]=true;
        folder1.add( settings, 'objet'+(i+1) ).onChange( showObject.bind({index:i}) )//ajoute un argument i en plus de la valeur true/false
    };
    folder1.open();
    panel.closed = true;    
};
function  showObject(visibility){
    objet3D[this.index].visible = visibility;
};
function showRotation( visibility ) {
    rotation = visibility;
};
function onWindowResize() {
    camera.aspect = container.clientWidth/container.clientHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(container.clientWidth, container.clientHeight);
    controls.handleResize();
    renderer.render(scene,camera);
    // Pour replacer le dat.GUI.
    containerGUI.style.top=container.offsetTop+1+'px';
    containerGUI.style.left=container.offsetLeft+container.clientWidth-146-3+'px';
};
function animate() {
    requestAnimationFrame(animate);
    if (rotation) {group.rotation.y += 0.01 };
    renderer.render(scene,camera);
    controls.update();
};

//programme principal
init();
//création du menu
createPanel();
// Pour placer correctement le panel dat.GUI.
containerGUI.style.top=container.offsetTop+1+'px';
containerGUI.style.left=container.offsetLeft+container.clientWidth-146-3+'px';
animate();   
