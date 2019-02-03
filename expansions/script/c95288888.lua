--妖怪大贤者·八云紫
function c95288888.initial_effect(c)
    --act limit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetRange(LOCATION_PZONE)
    e1:SetTargetRange(0,1)
    e1:SetValue(c95288888.limval)
    c:RegisterEffect(e1)
    --Increase ATK
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetValue(800)
    c:RegisterEffect(e2) 
    --Destroy
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(95288888,0))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e3:SetTarget(c95288888.destg)
    e3:SetOperation(c95288888.desop)
    c:RegisterEffect(e3)
end
function c95288888.limval(e,re,rp)
    local rc=re:GetHandler()
    return rc:IsLocation(LOCATION_MZONE) and re:IsActiveType(TYPE_MONSTER)
        and rc:IsType(TYPE_FUSION) and not rc:IsImmuneToEffect(e)
end
function c95288888.desfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x9528)
end
function c95288888.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(c95288888.desfilter,tp,LOCATION_ONFIELD,0,1,nil)
        and Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g1=Duel.SelectTarget(tp,c95288888.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g2=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,2,nil)
    g1:Merge(g2)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
end
function c95288888.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local tg=g:Filter(Card.IsRelateToEffect,nil,e)
    if tg:GetCount()>0 then
        Duel.Destroy(tg,REASON_EFFECT)
    end
end