mutable struct Parser
    nparticles::Int
    ntimesteps::Int
    fields::Vector{AbstractString}
    field_vars::Dict{AbstractString,AbstractMatrix} 


    function Parser(filename::String)
        lines = readlines(filename)
        natoms = parse(Int,lines[4])
        ntsteps = Int(length(lines)/(natoms+9))
        field_names = split(lines[9][21:end])
        field_vals = Dict([field_names[i]=>zeros(natoms,ntsteps) for i=1:length(field_names)]...)
        
        # Parsing action
        for i=1:ntsteps
            for j=1:natoms
                k = (i-1)*natoms + (i)*9 + j
                line = split(lines[k])[3:end]
                field_vals["x"][j,i] = parse(Float64,line[1])
                field_vals["y"][j,i] = parse(Float64,line[2])
                field_vals["z"][j,i] = parse(Float64,line[3])
                field_vals["vx"][j,i] = parse(Float64,line[4])
                field_vals["vy"][j,i] = parse(Float64,line[5])
                field_vals["vz"][j,i] = parse(Float64,line[6])
                field_vals["fx"][j,i] = parse(Float64,line[7])
                field_vals["fy"][j,i] = parse(Float64,line[8])
                field_vals["fz"][j,i] = parse(Float64,line[9])
            end 
        end 
        new(natoms, ntsteps, field_names, field_vals)
    end 
end 


function get_positions(parser::Parser)
    x = parser.field_vars["x"]
    y = parser.field_vars["y"]
    z = parser.field_vars["z"]
    (x,y,z)
end 

function get_velocities(parser::Parser)
    vx = parser.field_vars["vx"]
    vy = parser.field_vars["vy"]
    vz = parser.field_vars["vz"]
    (vx,vy,vz)
end 

function get_forces(parser::Parser)
    fx = parser.field_vars["fx"]
    fy = parser.field_vars["fy"]
    fz = parser.field_vars["fz"]
    (fx,fy,fz)
end 

function show(io::IO,parser::Parser)
    print(io,"LAMMPS Parser\n")
    print(io,"Number of atoms = $(parser.nparticles)\n")
    print(io,"Number of timestep = $(parser.ntimesteps)\n")
    print(io,"Fields = $(parser.fields)\n")
end 