--万华镜手杖-魔法红宝石
local m=4231007
local cm=_G["c"..m]
function cm.initial_effect(c)--red
    iFunc(c).c("RegisterEffect",iFunc(c)
        .e("SetType",EFFECT_TYPE_SINGLE)
        .e("SetCode",EFFECT_EQUIP_LIMIT)
        .e("SetProperty",EFFECT_FLAG_CANNOT_DISABLE)
        .e("SetValue",function(e,c)return c:IsRace(RACE_SPELLCASTER) end)
    .Return()).c("RegisterEffect",iFunc(c)
        .e("SetCategory",CATEGORY_EQUIP)
        .e("SetType",EFFECT_TYPE_ACTIVATE)
        .e("SetCode",EVENT_FREE_CHAIN)
        .e("SetProperty",EFFECT_FLAG_CARD_TARGET)
        .e("SetTarget",function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
            if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.eqfilter(chkc) end
            if chk==0 then return Duel.IsExistingTarget(cm.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
            e:SetLabel(0)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
            Duel.SelectTarget(tp,cm.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
            Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)end)
        .e("SetOperation",cm.operation)
    .Return()).c("RegisterEffect",iFunc(c)
        .e("SetType",EFFECT_TYPE_EQUIP)
        .e("SetCode",EFFECT_CANNOT_BE_EFFECT_TARGET)
        .e("SetProperty",EFFECT_FLAG_IGNORE_IMMUNE)
        .e("SetValue",aux.tgoval)
    .Return()).c("RegisterEffect",iFunc(c)
        .e("SetCategory",CATEGORY_SPECIAL_SUMMON)
        .e("SetType",EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)    
        .e("SetCode",EVENT_EQUIP)
        .e("SetRange",0xff)
        .e("SetProperty",EFFECT_FLAG_DELAY)
        .e("SetTarget",function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
            if e:GetHandler():GetEquipTarget()==nil then return false end
            if chk==0 then return iCount(0,tp,m,1) and e:GetHandler():GetEquipTarget():IsType(TYPE_NORMAL) 
                and e:GetHandler():GetEquipTarget() == re:GetHandler():GetEquipTarget()
                and re:GetOwner() == e:GetOwner()
                and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
                and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,4231002,e,tp) end 
Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1) end)
        .e("SetOperation",function(e,tp,eg,ep,ev,re,r,rp)
            local g = Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,4231002,e,tp)
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end)
    .Return()).c("RegisterEffect",iFunc(c)
        .e("SetDescription",aux.Stringid(m,0))
        .e("SetCategory",CATEGORY_EQUIP)
        .e("SetProperty",EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
        .e("SetType",EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
        .e("SetCode",EVENT_TO_GRAVE)
        .e("SetCondition",function (e,tp,eg,ep,ev,re,r,rp)
            local c=e:GetHandler()
            return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_DESTROY) and c:CheckUniqueOnField(tp)end)
        .e("SetTarget",function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
            if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.eqfilter(chkc) end
            if chk==0 then return iCount(0,tp,m,2) and e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
                and Duel.IsExistingTarget(cm.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
            e:SetLabel(1)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
            Duel.SelectTarget(tp,cm.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
            Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0) end)
        .e("SetOperation",cm.operation)
    .Return())
end
function cm.eqfilter(c)
    return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function cm.cfilter(c,code,e,tp)
    return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        if Duel.Equip(tp,c,tc)~=0 
            and Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
            if e:GetLabel()==0 then return end
            if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
                local g = Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
                Duel.Destroy(g,REASON_EFFECT)
            end        
        end
    end
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