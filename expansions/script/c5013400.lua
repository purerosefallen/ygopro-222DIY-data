--伊格尼兹
function c5013400.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),3,true)  
    --spsum
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(5013400,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCondition(c5013400.spcon)
    e2:SetTarget(c5013400.sptg)
    e2:SetOperation(c5013400.spop)
    c:RegisterEffect(e2)
    --chain attack
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(5013400,1))
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_BATTLE_DESTROYING)
    e3:SetCondition(c5013400.atcon)
    e3:SetOperation(c5013400.atop)
    c:RegisterEffect(e3)
    --disable
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_DISABLE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(0,LOCATION_MZONE)
    e4:SetCondition(c5013400.adcon)
    e4:SetTarget(c5013400.adtg)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_DISABLE_EFFECT)
    c:RegisterEffect(e5)
end
function c5013400.adcon(e)
    local c=e:GetHandler()
    return Duel.GetAttacker()==c and c:GetBattleTarget()
        and (Duel.GetCurrentPhase()==PHASE_DAMAGE or Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL)
end
function c5013400.adtg(e,c)
    return c==e:GetHandler():GetBattleTarget()
end
function c5013400.atcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return Duel.GetAttacker()==c and aux.bdocon(e,tp,eg,ep,ev,re,r,rp) and c:IsChainAttackable()
end
function c5013400.atop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToBattle() then return end
    Duel.ChainAttack()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE+PHASE_DAMAGE_CAL)
    c:RegisterEffect(e1)
end
function c5013400.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c5013400.spfilter(c,e,tp)
    return c:IsCode(5013400) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c5013400.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
        and Duel.IsExistingMatchingCard(c5013400.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c5013400.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCountFromEx(tp)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c5013400.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end