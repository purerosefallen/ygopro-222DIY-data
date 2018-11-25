--箱型恐惧
local m=4212211
local cm=_G["c"..m]
function cm.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,function(c) return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_DARK) and c:GetBaseAttack() <= 1000 end,3,3)
    c:EnableReviveLimit()
    iFunc(c).c("RegisterEffect",iFunc(c)
        .e("SetProperty",EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        .e("SetType",EFFECT_TYPE_SINGLE)
        .e("SetCode",EFFECT_SPSUMMON_CONDITION)
        .e("SetValue",aux.xyzlimit)
    .Return()).c("RegisterEffect",iFunc(c)
        .e("SetType",EFFECT_TYPE_FIELD)
        .e("SetRange",LOCATION_ONFIELD)
        .e("SetTarget",function(e,c) return c~=e:GetHandler() and c:IsType(TYPE_EFFECT) end)
        .e("SetTargetRange",LOCATION_MZONE,LOCATION_MZONE)
        .e("SetCode",EFFECT_DISABLE)
    .Return()).c("RegisterEffect",iFunc(c)
        .e("SetType",EFFECT_TYPE_FIELD)
        .e("SetCode",EFFECT_CANNOT_DISEFFECT)
        .e("SetRange",LOCATION_ONFIELD)
        .e("SetValue",function(e,ct)
            local p=e:GetHandler():GetControler()
            local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
            return te:GetHandler():IsType(TYPE_EFFECT) and bit.band(loc,LOCATION_MZONE)~=0
        end)
    .Return()).c("RegisterEffect",iFunc(c)
        .e("SetType",EFFECT_TYPE_QUICK_F)
        .e("SetCode",EVENT_CHAINING)
        .e("SetRange",LOCATION_MZONE)
        .e("SetCondition",function(e,tp,eg,ep,ev,re,r,rp)
            return re:GetActivateLocation()==LOCATION_GRAVE end)
        .e("SetTarget",function(e,tp,eg,ep,ev,re,r,rp,chk)
            if chk==0 then return true end end) 
        .e("SetOperation",function(e,tp,eg,ep,ev,re,r,rp)
            if e:GetHandler():IsFacedown() then return end
            Duel.Overlay(e:GetHandler(),re:GetHandler())
        end)
    .Return()).c("RegisterEffect",iFunc(c)
        .e("SetDescription",aux.Stringid(m,2))
        .e("SetCategory",CATEGORY_DESTROY)
        .e("SetType",EFFECT_TYPE_QUICK_O)
        .e("SetCode",EVENT_FREE_CHAIN)
        .e("SetRange",LOCATION_MZONE)
        .e("SetCost",function(e,tp,eg,ep,ev,re,r,rp,chk)
            if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,3,REASON_COST) end
            e:GetHandler():RemoveOverlayCard(tp,3,3,REASON_COST) end)
        .e("SetTarget",function(e,tp,eg,ep,ev,re,r,rp,chk)
            if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
            local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
            Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
            Duel.SetChainLimit(aux.FALSE) end) 
        .e("SetOperation",function(e,tp,eg,ep,ev,re,r,rp)
            local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
            if g:GetCount()>0 then
                Duel.Destroy(g,REASON_EFFECT)
            end end)
    .Return())
end
function iFunc(c,x)
    local __this = (aux.GetValueType(c) == "Card" and {(x == nil and {Effect.CreateEffect(c)} or {x})[1]} or {x})[1] 
    local fe = function(name,...) (type(__this[name])=="function" and {__this[name]} or {""})[1](__this,...) return iFunc(c,__this) end
    local fc = function(name,...) this = (type(c[name])=="function" and {c[name]} or {""})[1](c,...) return iFunc(c,c) end  
    local func ={e = fe,c = fc,g = fc,v = function() return this end,Return = function() return __this:Clone() end}
    return func
end