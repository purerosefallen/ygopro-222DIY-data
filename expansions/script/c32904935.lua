--Shi the Aeonbreaker's Maiden
function c32904935.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xaa12),aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),true)
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.fuslimit)
    c:RegisterEffect(e1)
    --equip
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(32904935,0))
    e2:SetCategory(CATEGORY_EQUIP)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetHintTiming(0,0x1e0)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c32904935.eqcon)
    e2:SetTarget(c32904935.eqtg)
    e2:SetOperation(c32904935.eqop)
    c:RegisterEffect(e2)
    --destroy + lp gain
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(32904935,1))
    e3:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(c32904935.target)
    e3:SetOperation(c32904935.operation)
    c:RegisterEffect(e3)
    --remove
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(32904935,2))
    e4:SetCategory(CATEGORY_REMOVE)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_BE_MATERIAL)
    e4:SetCondition(c32904935.rmcon)
    e4:SetTarget(c32904935.rmtg)
    e4:SetOperation(c32904935.rmop)
    c:RegisterEffect(e4)
    --special summon
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(32904935,3))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e5:SetRange(LOCATION_GRAVE)
    e5:SetCountLimit(1)
    e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e5:SetCondition(c32904935.spcon)
    e5:SetTarget(c32904935.sptg)
    e5:SetOperation(c32904935.spop)
    e5:SetLabelObject(e4)
    c:RegisterEffect(e5)
end
function c32904935.eqcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end
function c32904935.eqfilter(c,tp)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER)
        and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function c32904935.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and c32904935.eqfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c32904935.eqfilter,tp,0,LOCATION_GRAVE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,c32904935.eqfilter,tp,0,LOCATION_GRAVE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c32904935.eqop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not (tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsType(TYPE_MONSTER)) then return end
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local atk=tc:GetTextAttack()
        if atk<0 then atk=0 end
        if Duel.Equip(tp,tc,c)==0 then return end
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_EQUIP)
        e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
        e1:SetCode(EFFECT_UPDATE_DEFENSE)
        e1:SetValue(atk)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e2:SetCode(EFFECT_EQUIP_LIMIT)
        e2:SetValue(c32904935.eqlimit)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e2)
    else Duel.SendtoGrave(tc,REASON_EFFECT) end
end
function c32904935.eqlimit(e,c)
    return e:GetOwner()==c
end
function c32904935.desfilter(c,ec)
    return c:GetEquipTarget()==ec and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0
end
function c32904935.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c32904935.desfilter(chkc,c) end
    if chk==0 then return Duel.IsExistingTarget(c32904935.desfilter,tp,LOCATION_SZONE,0,1,nil,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c32904935.desfilter,tp,LOCATION_SZONE,0,1,1,nil,c)
    local atk=g:GetFirst():GetTextAttack()
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    if atk>0 then
        Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
    end
end
function c32904935.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
        local atk=tc:GetTextAttack()
        Duel.Recover(tp,atk,REASON_EFFECT)
    end
end
function c32904935.rmcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsLocation(LOCATION_GRAVE) and r==REASON_FUSION and c:GetReasonCard():IsSetCard(0xaa12)
end
function c32904935.filter(c)
    return c:IsLevelBelow(4) and c:IsRace(RACE_PSYCHO) and c:IsAbleToRemove()
end
function c32904935.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c32904935.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c32904935.rmop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c32904935.filter,tp,LOCATION_DECK,0,1,1,nil)
    local tc=g:GetFirst()
    local c=e:GetHandler()
    if tc then
        Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
        if c:IsRelateToEffect(e) then
            c:RegisterFlagEffect(32904935,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,2)
            tc:RegisterFlagEffect(32904935,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,2)
            e:SetLabelObject(tc)
        end
    end
end
function c32904935.spcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject():GetLabelObject()
    local c=e:GetHandler()
    return tc and Duel.GetTurnCount()~=tc:GetTurnID()
        and c:GetFlagEffect(32904935)~=0 and tc:GetFlagEffect(32904935)~=0
end
function c32904935.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=e:GetLabelObject():GetLabelObject()
    if chk==0 then return tc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    tc:CreateEffectRelation(e)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
end
function c32904935.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject():GetLabelObject()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end