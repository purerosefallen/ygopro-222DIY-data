--奥特战士 希卡利
local m=14801309
local cm=_G["c"..m]
function cm.initial_effect(c)
    --end battle phase
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetCountLimit(1,m)
    e1:SetCondition(cm.condition)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.operation)
    c:RegisterEffect(e1)
    --atk/def
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(0,LOCATION_MZONE)
    e2:SetValue(-500)
    e2:SetCondition(cm.tgcon)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e3)
    --cannot target
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e4:SetValue(aux.tgoval)
    c:RegisterEffect(e4)
    
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    local at=Duel.GetAttacker()
    return at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)>0 then
    c:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetCountLimit(1)
        e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e1:SetLabelObject(c)
        e1:SetCondition(cm.descon)
        e1:SetOperation(cm.desop)
        Duel.RegisterEffect(e1,tp)
        local atk=c:GetBaseAttack()
        local def=c:GetBaseDefense()
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_SET_BASE_ATTACK)
        e2:SetValue(atk/2)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
        c:RegisterEffect(e2)
        local e3=e2:Clone()
        e3:SetCode(EFFECT_SET_BASE_DEFENSE)
        e3:SetValue(def/2)
        c:RegisterEffect(e3)
        Duel.SpecialSummonComplete()
    end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    if tc:GetFlagEffect(m)~=0 then
        return true
    else
        e:Reset()
        return false
    end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    Duel.SendtoGrave(tc,nil,REASON_EFFECT)
end
function cm.tgcon(e)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end