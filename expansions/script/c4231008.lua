--万华镜的仪式-人理修复
local m=4231008
local cm=_G["c"..m]
function cm.initial_effect(c)
    iFunc(c).c("RegisterEffect",iFunc(c)
        .e("SetType",EFFECT_TYPE_SINGLE)
        .e("SetCode",EFFECT_EQUIP_LIMIT)
        .e("SetProperty",EFFECT_FLAG_CANNOT_DISABLE)
        .e("SetValue",function(e,c)return c:IsRace(RACE_SPELLCASTER) end)
    .Return()).c("RegisterEffect",iFunc(c)
        .e("SetType",EFFECT_TYPE_EQUIP)
        .e("SetCode",EFFECT_EXTRA_ATTACK)
        .e("SetProperty",EFFECT_FLAG_CANNOT_DISABLE)
        .e("SetRange",LOCATION_SZONE)
        .e("SetValue",function(e)return e:GetHandler():GetEquipTarget():GetEquipCount()-1 end)
    .Return()).c("RegisterEffect",iFunc(c)
        .e("SetType",EFFECT_TYPE_ACTIVATE)
        .e("SetCode",EVENT_FREE_CHAIN)
        .e("SetProperty",EFFECT_FLAG_CARD_TARGET)
        .e("SetTarget",function(e,tp,eg,ep,ev,re,r,rp,chk)
            if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.eqfilter(chkc) end
            if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingTarget(cm.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
            Duel.SelectTarget(tp,cm.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil) end)
        .e("SetOperation",function(e,tp,eg,ep,ev,re,r,rp,chk)
            local c=e:GetHandler()
            local tc=Duel.GetFirstTarget()
            if c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
                if Duel.Equip(tp,c,tc)~=0  then
                    local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_DECK,0,1,1,nil,e)
                    if g:GetCount()>0 then Duel.SendtoHand(g,nil,REASON_EFFECT)  Duel.ConfirmCards(1-tp,g) end
                end
            end end)
    .Return()).c("RegisterEffect",iFunc(c)
        .e("SetCategory",CATEGORY_TOHAND)
        .e("SetType",EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)    
        .e("SetCode",EVENT_EQUIP)
        .e("SetRange",0xff)
        .e("SetProperty",EFFECT_FLAG_DELAY)
        .e("SetTarget",function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
            if e:GetHandler():GetEquipTarget()==nil then return false end
            if chk==0 then return iCount(0,tp,m,1) and e:GetHandler():GetEquipTarget():IsType(TYPE_NORMAL) 
                and eg:IsContains(e:GetHandler())
                and Duel.IsExistingMatchingCard(cm.gfilter,tp,LOCATION_GRAVE,0,1,nil) end 
Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1) end)
        .e("SetOperation",function(e,tp,eg,ep,ev,re,r,rp)
            local g = Duel.SelectMatchingCard(tp,cm.gfilter,tp,LOCATION_GRAVE,0,1,1,nil)
            if g:GetCount()>0 then Duel.SendtoHand(g,nil,REASON_EFFECT)  Duel.ConfirmCards(1-tp,g) end end)
    .Return())
end
function cm.cfilter(c) 
    return c:IsCode(4231005) and c:IsAbleToHand()
end
function cm.gfilter(c) 
    return c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.eqfilter(c)
    return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_MONSTER)
end
function iCount(name,tp,m,id)
    return ((name=="get" or name=="set")
        and {(name=="get"
            and {tonumber(((Duel.GetFlagEffect(tp,m)==nil) and {0} or {Duel.GetFlagEffect(tp,m)})[1])} 
            or { Debug.Message("","请使用Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)") })[1]}
        or {(bit.band(iCount("get",tp,m,id),math.pow(2,id-1))==0 and {true} or {false})[1]})[1]
end
function iFunc(c,x)
    local __this = (aux.GetValueType(c) == "Card" and {(x == nil and {Effect.CreateEffect(c)} or {x})[1]} or {x})[1] 
    local fe = function(name,...) (type(__this[name])=="function" and {__this[name]} or {""})[1](__this,...) return iFunc(c,__this) end
    local fc = function(name,...) this = (type(c[name])=="function" and {c[name]} or {""})[1](c,...) return iFunc(c,c) end  
    local func ={e = fe,c = fc,g = fc,v = function() return this end,Return = function() return __this:Clone() end}
    return func
end