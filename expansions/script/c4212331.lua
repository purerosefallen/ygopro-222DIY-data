--时钟机关工作室-琉紫
local m=4212331
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddXyzProcedure(c,function(c) return c:IsSetCard(0xa25) end,3,3)
    iFunc(c).c("RegisterEffect",iFunc(c)        
        .e("SetType",EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        .e("SetCode",EVENT_ATTACK_ANNOUNCE)
        .e("SetRange",LOCATION_MZONE,LOCATION_MZONE)
        .e("SetTarget",function(e,tp,eg,ep,ev,re,r,rp,chk)
            if chk==0 then return e:GetHandler():GetBattleTarget() end
            Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetHandler():GetAttack() / 2)
        end)
        .e("SetOperation",function(e,tp,eg,ep,ev,re,r,rp) 
            Duel.NegateAttack() 
            Duel.Damage(1-tp,e:GetHandler():GetAttack() / 2,REASON_BATTLE)
            end)
    .Return()).c("RegisterEffect",iFunc(c)        
        .e("SetType",EFFECT_TYPE_SINGLE)
        .e("SetCode",EFFECT_IMMUNE_EFFECT)
        .e("SetProperty",EFFECT_FLAG_SINGLE_RANGE)
        .e("SetRange",LOCATION_MZONE)
        .e("SetValue",function(e,te) 
            return not (te:GetOwner():IsSetCard(0xa25) or te:GetOwner():IsRace(RACE_THUNDER)) end)
    .Return()).c("RegisterEffect",iFunc(c)        
        .e("SetType",EFFECT_TYPE_FIELD)
        .e("SetCode",EFFECT_DISABLE)
        .e("SetRange",LOCATION_MZONE)
        .e("SetTargetRange",LOCATION_MZONE,LOCATION_MZONE)
        .e("SetTarget",function(e,c)
            local cg=c:GetColumnGroup()
            return not Duel.IsExistingMatchingCard(cm.fliter,tp,LOCATION_SZONE,LOCATION_SZONE,1,e:GetHandler(),cg) end)
    .Return())
end
function cm.fliter(c,cg)
    return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsSetCard(0xa25) and cg:IsContains(c)
end
function iFunc(c,x)
    local __this = (aux.GetValueType(c) == "Card" and {(x == nil and {Effect.CreateEffect(c)} or {x})[1]} or {x})[1] 
    local fe = function(name,...) if name =="RegisterEffect" then c:RegisterEffect(__this:Clone()) else (type(__this[name])=="function" and {__this[name]} or {""})[1](__this,...) end return iFunc(c,__this) end
    local fc = function(name,...) this = (type(c[name])=="function" and {c[name]} or {""})[1](c,...) return iFunc(c,c) end  
    local func ={e = fe,Clone = fe,c = fc,g = fc,v = function() return this end,Return = function() return __this:Clone() end}
    return func
end