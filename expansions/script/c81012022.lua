--财前时子
function c81012022.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,nil,3,3,c81012022.lcheck)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCountLimit(1,81012022)
    e2:SetCondition(c81012022.spcon)
    e2:SetTarget(c81012022.sptg)
    e2:SetOperation(c81012022.spop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_MATERIAL_CHECK)
    e3:SetValue(c81012022.valcheck)
    e3:SetLabelObject(e2)
    c:RegisterEffect(e3)
    --recover
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(81012022,0))
    e4:SetCategory(CATEGORY_RECOVER)
    e4:SetCode(EVENT_BATTLE_DESTROYING)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCondition(c81012022.condition)
    e4:SetTarget(c81012022.target)
    e4:SetOperation(c81012022.operation)
    c:RegisterEffect(e4)
end
function c81012022.lcheck(g)
    return g:GetClassCount(Card.GetLinkAttribute)==g:GetCount()
end
function c81012022.valcheck(e,c)
    local g=c:GetMaterial()
    local val=0
    for tc in aux.Next(g) do
        val=bit.bor(val,tc:GetAttribute())
    end
    e:GetLabelObject():SetLabel(val)
end
function c81012022.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetHandler():GetMaterialCount()==3
end
function c81012022.spfilter(c,e,tp,rc)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and not c:IsAttribute(rc)
end
function c81012022.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c81012022.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,e:GetLabel()) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c81012022.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c81012022.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,e:GetLabel())
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
    end
end
function c81012022.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c81012022.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    local dam=bc:GetAttack()
    if dam<0 then dam=0 end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(dam)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,dam)
end
function c81012022.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
end
