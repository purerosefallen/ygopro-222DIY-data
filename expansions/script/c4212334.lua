--时钟机关工作室-昂可儿
local m=4212334
local cm=_G["c"..m]
function cm.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,function(c) return c:IsSetCard(0xa25) end,3,3)
    iFunc(c).c("RegisterEffect",iFunc(c)        
        .e("SetType",EFFECT_TYPE_SINGLE)
        .e("SetCode",EFFECT_UPDATE_ATTACK)
        .e("SetProperty",EFFECT_FLAG_SINGLE_RANGE)
        .e("SetRange",LOCATION_MZONE)
        .e("SetValue",function(e,c)
            local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA):Filter(function(c) return c:IsFaceup() and c:IsType(TYPE_MONSTER) end,1,99)
            local atk=0
            local tc=g:GetFirst()
            while tc do
                local batk=tc:GetTextAttack()
                if batk>0 then
                    atk=atk+batk
                end
                tc=g:GetNext()
            end
            return 1000 end)
    .Clone("RegisterEffect")
        .e("SetCode",EFFECT_UPDATE_DEFENSE)
    .Return()).c("RegisterEffect",iFunc(c)
        .e("SetType",EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
        .e("SetCode",EVENT_TO_HAND)
        .e("SetProperty",EFFECT_FLAG_DELAY)
        .e("SetRange",LOCATION_MZONE)
        .e("SetCondition",cm.drcon1)
        .e("SetOperation",cm.drop1)
    .Return()).c("RegisterEffect",iFunc(c)
        .e("SetType",EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
        .e("SetCode",EVENT_TO_HAND)
        .e("SetRange",LOCATION_MZONE)
        .e("SetCondition",cm.regcon)
        .e("SetOperation",cm.regop)
    .Return()).c("RegisterEffect",iFunc(c)
        .e("SetType",EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
        .e("SetCode",EVENT_CHAIN_SOLVED)
        .e("SetRange",LOCATION_MZONE)
        .e("SetCondition",cm.drcon2)
        .e("SetOperation",cm.drop2)
    .Return()).c("RegisterEffect",iFunc(c)
        .e("SetType",EFFECT_TYPE_SINGLE)
        .e("SetCode",EFFECT_UPDATE_ATTACK)
        .e("SetProperty",EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
        .e("SetRange",LOCATION_MZONE)
        .e("SetCondition",function(e)
            return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget() end)
        .e("SetValue",function(e,c)return Duel.GetAttackTarget():GetAttack()/2 end)
    .Return())
end
function cm.cfilter(c,tp)
    return c:IsControler(1-tp) and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_DRAW) 
end
function cm.sgfilter(c,e,tp)
    return c:IsDestructable(c) and not c:IsImmuneToEffect(e)
end
function cm.drcon1(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.cfilter,1,nil,tp) 
        and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.cfilter,1,nil,tp) and Duel.GetFlagEffect(tp,m)==0 
        and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function cm.drcon2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFlagEffect(tp,m)>0
end
function cm.drop1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,m)
    local g = Duel.SelectMatchingCard(1-tp,cm.sgfilter,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,1,nil,e,tp)
    Duel.Destroy(g,REASON_EFFECT)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
    Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
end
function cm.drop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.ResetFlagEffect(tp,m)
    Duel.Hint(HINT_CARD,0,m)
    local g = Duel.SelectMatchingCard(1-tp,cm.sgfilter,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,1,nil,e,tp)
    Duel.Destroy(g,REASON_EFFECT)
end
function iFunc(c,x)
    local __this = (aux.GetValueType(c) == "Card" and {(x == nil and {Effect.CreateEffect(c)} or {x})[1]} or {x})[1] 
    local fe = function(name,...) if name =="RegisterEffect" then c:RegisterEffect(__this:Clone()) else (type(__this[name])=="function" and {__this[name]} or {""})[1](__this,...) end return iFunc(c,__this) end
    local fc = function(name,...) this = (type(c[name])=="function" and {c[name]} or {""})[1](c,...) return iFunc(c,c) end  
    local func ={e = fe,Clone = fe,c = fc,g = fc,v = function() return this end,Return = function() return __this:Clone() end}
    return func
end