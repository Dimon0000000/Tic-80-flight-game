--made by Limpid
--2023/3/21
score=0	

p={
  x=10,
  y=55,
  vx=0,
  vy=0,
  w=20,
  h=20,
  c=2,
  b=20, --blood
  i=288, --id
  die=false,
  r="p" --role=player
}

gos={}

table.insert(gos,p)

function draw_gameover()
  print("Game Over",50,50,2)
  print("press 'z' to restrat",20,60,3)
end

function checkCollision(a, b)
    --With locals it's common usage to use underscores instead of camelCasing
    local a_left = a.x
    local a_right = a.x + a.w
    local a_top = a.y
    local a_bottom = a.y + a.h

    local b_left = b.x
    local b_right = b.x + b.w
    local b_top = b.y
    local b_bottom = b.y + b.h

    --Directly return this boolean value without using if-statement
    return  a_right > b_left
        and a_left < b_right
        and a_bottom > b_top
        and a_top < b_bottom
end

function newenemy()
 local e={
    x=239,
    y=math.random(0,135),
    vx=-1,
    vy=0,
    w=10,
    h=10,
    c=12,
    die=false,
    i=272,
    r="e" --role enemy
  }
  table.insert(gos,e) --add enemy to gameobjects
end

function fire()
  --bullet
  local b={
    w=2,
    h=2,
    x=p.x+p.w/2-1,
    y=p.y,
    vx=2,
    vy=0,
    r="b", --bullet
    i=289 --id
  }
  table.insert(gos,b)
end

function draw_blood()
  -- draw blood
  spr(256,10,10,0,1,0,0,1,1)
  rect(20,12,p.b,1,2)
end

function input()
  if btn(0) then
    p.vy=-1
  elseif btn(1) then
    p.vy=1
  elseif btn(2) then
    p.vx=-1
  elseif btn(3) then
    p.vx=1
  else
    p.vx=0
    p.vy=0
  end
  -- 如果玩家血没了 并且按了z键，则重新开始游戏
  if btn(4) and p.b==0 then
    reset() --restart game
  end
  
  if btnp(5) and p.b>0 then
  fire()
end   
end

function update()
		if p.b==0 then
				return false
		end

  for i,v in ipairs(gos) do
  		if v.r=="p" then
   		stay_on_screen(v)
				end
				
				if v.r=="e" and v.x<=-1*v.w then
 			 v.die=true
				end
				
				if v.r=="b" and v.x>239 then
  		 v.die=true
				end
    v.x=v.x+v.vx
    v.y=v.y+v.vy
    for ii,vv in ipairs(gos) do
      if checkCollision(v,vv) then
        if v.r=="p" and vv.r=="e" then
          vv.die=true 
          v.b=v.b-5
        end
        if v.r=="b" and vv.r=="e" then
   v.die=true
   vv.die=true
   score=score+1
end
      end
    end
  end
  for i,v in ipairs(gos) do
    if v.die then
      table.remove(gos,i)
    end
end
end

function draw()
print("SCORE "..score,10,20,12)
  for i,v in ipairs(gos) do
    spr(v.i,v.x,v.y,0,1,0,0,1,1) --使用spr方法代替之前的rect方法
  end
  draw_blood()
  if p.b==0 then
    draw_gameover()
  end
end

function stay_on_screen(v)
  if v.x<=0 then
    v.x=0
  end
  if v.y<=0 then
    v.y=0
  end
  if v.x>=239-v.w then
    v.x=239-v.w
  end
  if v.y>135-v.h then
    v.y=135-v.h
  end
end

function tup()
  if t%50==0 then
    newenemy()
  end
end

t=0
function TIC()
  t=t+1
  tup() --t update
  input()
  update()
  cls(0)
  draw()
end