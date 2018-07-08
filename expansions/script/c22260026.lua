--茧墨阿座化与她愉快的伙伴们
function c22260026.initial_effect(c)
    c:EnableReviveLimit()
    --atkup
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetTarget(c22260026.atktg)
    e1:SetValue(c22260026.atkval)
    c:RegisterEffect(e1)
    --direct attack
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_DIRECT_ATTACK)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(c22260026.dirtg)
    c:RegisterEffect(e2)
    --Token&Recover
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOKEN+CATEGORY_RECOVER)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(c22260026.tkcon)
    e3:SetTarget(c22260026.tktg)
    e3:SetOperation(c22260026.tgop)
    c:RegisterEffect(e3)
end
c22260026.named_with_MayuAzaka=1
c22260026.Desc_Contain_MayuAzaka=1
function c22260026.IsMayuAzaka(c)
    local m=_G["c"..c:GetCode()]
    return m and m.named_with_MayuAzaka
end
--
function c22260026.atktg(e,c)
    return c:GetBaseAttack()==0
end
function c22260026.atkfilter(c)
    return c:IsType(TYPE_SPELL) and c:IsPosition(POS_FACEUP)
end
function c22260026.atkval(e,c)
    return Duel.GetMatchingGroupCount(c22260026.atkfilter,c:GetControler(),LOCATION_SZONE,0,nil)*700
end
--
function c22260026.dirtg(e,c)
    return c:GetBaseAttack()==0
end
--
function c22260026.tkcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c22260026.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
       and Duel.IsPlayerCanSpecialSummonMonster(tp,22269998,nil,0x4011,0,0,11,RACE_FAIRY,ATTRIBUTE_DARK) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
    end
function c22260026.tgop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if Duel.IsPlayerCanSpecialSummonMonster(tp,22269998,nil,0x4011,0,0,11,RACE_FAIRY,ATTRIBUTE_DARK) then
    local token=Duel.CreateToken(tp,22269998)
    Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
        Duel.BreakEffect()
        Duel.Recover(tp,1000,REASON_EFFECT)
    end
end