// =================================================================
// PARÂMETROS DA GAVETA (Medidas externas em mm)
// =================================================================

largura_gaveta = 500;  // Largura total da gaveta
profund_gaveta = 450;  // Profundidade da gaveta
altura_gaveta  = 150;  // Altura da gaveta
mdf_lateral    = 15;   // Espessura das peças laterais/frentes
mdf_fundo      = 6;    // Espessura do fundo
rasgo_fundo    = 8;    // Profundidade do rebaixo/canal do fundo
folga_fundo    = 10;   // Altura do chão até o início do fundo

modo_2d        = true; // false = Modelo 3D | true = Chapas 2D para CNC/DXF
espacamento    = 20;    // Espaçamento entre peças no modo 2D


// =================================================================
// MEDIDAS CALCULADAS
// =================================================================

comprimento_frente = largura_gaveta - (2 * mdf_lateral);
largura_fundo      = comprimento_frente + (2 * rasgo_fundo);
profund_fundo      = profund_gaveta - (2 * mdf_lateral) + (2 * rasgo_fundo);


// =================================================================
// MÓDULOS 3D DAS PEÇAS
// =================================================================

// Lateral 3D (Canal orientado para o lado interno Y+)
module lateral_3d() {
    difference() {
        cube([profund_gaveta, mdf_lateral, altura_gaveta]);
        // Canal do fundo
        translate([0, 0, folga_fundo])
            cube([profund_gaveta, rasgo_fundo, mdf_fundo]);
    }
}

// Frente/Contra-Frente 3D (Canal orientado para o lado interno X+)
module frente_3d() {
    difference() {
        cube([mdf_lateral, comprimento_frente, altura_gaveta]);
        // Canal do fundo
        translate([0, 0, folga_fundo])
            cube([rasgo_fundo, comprimento_frente, mdf_fundo]);
    }
}

// Fundo 3D
module fundo_3d() {
    cube([profund_fundo, largura_fundo, mdf_fundo]);
}


// =================================================================
// DESENHOS VETORIAIS 2D (Para Fresadora CNC)
// =================================================================

// Desenha a chapa lateral deitada no 2D incluindo a linha do rasgo/canal
module lateral_2d() {
    // Contorno externo da peça
    square([profund_gaveta, altura_gaveta]);
    
    // Linha do canal (para usinagem de rebaixo na CNC)
    translate([0, folga_fundo])
        square([profund_gaveta, mdf_fundo]);
}

// Desenha a chapa da frente deitada no 2D incluindo a linha do rasgo/canal
module frente_2d() {
    // Contorno externo da peça
    square([comprimento_frente, altura_gaveta]);
    
    // Linha do canal (para usinagem de rebaixo na CNC)
    translate([0, folga_fundo])
        square([comprimento_frente, mdf_fundo]);
}


// =================================================================
// MONTAGEM 3D (Peças encaixadas corretamente)
// =================================================================

module montagem_3d() {
    // 1. Lateral Esquerda (Canal virado para dentro)
    lateral_3d();
    
    // 2. Lateral Direita (Canal virado para dentro)
    translate([0, largura_gaveta - mdf_lateral, 0])
        mirror([0, 1, 0]) // Espelha para o canal ficar virado para dentro
            translate([0, -mdf_lateral, 0])
                lateral_3d();
    
    // 3. Frente (Encaixada entre as laterais)
    translate([0, mdf_lateral, 0])
        frente_3d();
        
    // 4. Contra-Frente / Costas
    translate([profund_gaveta - mdf_lateral, mdf_lateral, 0])
        mirror([1, 0, 0]) // Espelha para o canal ficar virado para dentro
            translate([-mdf_lateral, 0, 0])
                frente_3d();
            
    // 5. Placa do Fundo (Encaixada dentro dos 4 canais)
    translate([mdf_lateral - rasgo_fundo, mdf_lateral - rasgo_fundo, folga_fundo])
        fundo_3d();
}


// =================================================================
// PLANO DE CORTE 2D (Chapas organizadas para DXF/SVG)
// =================================================================

module plano_corte_2d() {
    // Lateral 1
    lateral_2d();
    
    // Lateral 2
    translate([0, altura_gaveta + espacamento])
        lateral_2d();
            
    // Frente 1
    translate([profund_gaveta + espacamento, 0])
        frente_2d();
            
    // Frente 2 (Costas)
    translate([profund_gaveta + espacamento, altura_gaveta + espacamento])
        frente_2d();
            
    // Fundo
    translate([profund_gaveta + comprimento_frente + (2 * espacamento), 0])
        square([profund_fundo, largura_fundo]);
}


// =================================================================
// RENDERIZAÇÃO FINAL
// =================================================================

if (modo_2d) {
    plano_corte_2d();
} else {
    montagem_3d();
}