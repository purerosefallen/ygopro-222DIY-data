--占星少女的召唤魔法阵
function c22600221.initial_effect(c)
    c:SetUniqueOnField(1,0,22600221)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --cannot disable summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
    e2:SetRange(LOCATION_SZONE)
    e2:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x262))
    e2:SetCondition(c22600221.con1)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    c:RegisterEffect(e3)
    --destroy replace
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EFFECT_DESTROY_REPLACE)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCondition(c22600221.con2)
    e4:SetTarget(c22600221.reptg)
    e4:SetValue(c22600221.repval)
    e4:SetOperation(c22600221.repop)
    c:RegisterEffect(e4)
    --spsummon
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetCountLimit(1)
    e5:SetRange(LOCATION_SZONE)
    e5:SetCondition(c22600221.con3)
    e5:SetTarget(c22600221.sptg)
    e5:SetOperation(c22600221.spop)
    c:RegisterEffect(e5)
end
function c22600221.filter(c)
    return c:IsType(TYPE_LINK)
end
function c22600221.con1(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c22600221.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    local sg=g:GetSum(Card.GetLink)
    return sg>=2
end
function c22600221.con2(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c22600221.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    local sg=g:GetSum(Card.GetLink)
    return sg>=4
end
function c22600221.repfilter(c,tp)
    return c:IsFaceup() and c:IsSetCard(0x262) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c22600221.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) and eg:IsExists(c22600221.repfilter,1,nil,tp) end
    return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c22600221.repval(e,c)
    return c22600221.repfilter(c,e:GetHandlerPlayer())
end
function c22600221.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
    Duel.SendtoDeck(g,tp,0,REASON_EFFECT)
end
function c22600221.con3(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c22600221.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    local sg=g:GetSum(Card.GetLink)
    return sg>=6
end
function c22600221.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function c22600221.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
    Duel.ConfirmDecktop(tp,1)
    Duel.BreakEffect()
    local g=Duel.GetDecktopGroup(tp,1)
    local tc=g:GetFirst()
    if tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0x262) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
        Duel.DisableShuffleCheck()
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    else
        Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
        Duel.ShuffleDeck(tp)
    end
end