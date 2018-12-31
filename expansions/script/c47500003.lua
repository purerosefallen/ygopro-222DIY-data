--枪神 姬塔
local m=47500003
local c47500003=_G["c"..m]
function c47500003.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c) 
    --effect gian
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_ADJUST)
    e1:SetRange(LOCATION_MZONE)
    e1:SetOperation(c47500003.efop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,47500003)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetTarget(c47500003.sptg)
    e2:SetOperation(c47500003.spop)
    c:RegisterEffect(e2)  
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_EXTRA_ATTACK)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(c47500003.atkval)
    c:RegisterEffect(e3)    
    --summon
    local e4=Effect.CreateEffect(c)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_SUMMON_PROC)
    e4:SetRange(LOCATION_HAND)
    e4:SetCondition(c47500003.ntcon)
    c:RegisterEffect(e4)
    --equip
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e7:SetCode(EVENT_SUMMON_SUCCESS)
    e7:SetOperation(c47500003.sumop)
    c:RegisterEffect(e7)  
    --code
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetCode(EFFECT_CHANGE_CODE)
    e5:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA)
    e5:SetValue(47500000)
    c:RegisterEffect(e5)
end
c47500003.card_code_list={47500000}
function c47500003.atkval(e,c)
    return c:GetEquipCount()
end
function c47500003.eqfilter(c)
    return c:IsFaceup() and c:IsAbleToChangeControler()
end
function c47500003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,c47500003.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c47500003.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
        Duel.Equip(tp,tc,c,false)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(c47500003.eqlimit)
        tc:RegisterEffect(e1)
    end
end
function c47500003.eqlimit(e,c)
    return e:GetOwner()==c
end
function c47500003.thfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c47500003.sumop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c47500003.thfilter,tp,0,LOCATION_MZONE,1,1,nil)
    local c=e:GetHandler()
    local tc=g:GetFirst()
    if tc and Duel.SendtoGrave(tc,REASON_EFFECT) then
        local code=tc:GetOriginalCode()
        local atk=tc:GetTextAttack()
        c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetRange(LOCATION_MZONE)
        e1:SetValue(atk/2)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e1)
    end
end
function c47500003.ntcon(e,c,minc)
    if c==nil then return true end
    return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
end
function c47500003.rtgfilter(c)
    return c:GetOriginalType(TYPE_MONSTER) and c:GetOriginalType(TYPE_EFFECT)
end
function c47500003.efop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()  
    local eq=c:GetEquipGroup(c47500003.rtgfilter,1,nil,tp)
    local wg=eq:Filter(c47500003.rtgfilter,nil,tp)
    local wbc=wg:GetFirst()
    while wbc do
        local code=wbc:GetOriginalCode()
        if c:IsFaceup() and c:GetFlagEffect(code)==0 then
        c:CopyEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING, 1)
        c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING,0,1)  
        end 
        wbc=wg:GetNext()
    end  
end