--占星少女的通灵魔法阵
function c22600222.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_END_PHASE)
    c:RegisterEffect(e1)
    --specialsummon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(0,TIMING_END_PHASE)
    e2:SetCountLimit(1,22600222)
    e2:SetTarget(c22600222.sptg)
    e2:SetOperation(c22600222.spop)
    c:RegisterEffect(e2)
    --damage
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DAMAGE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,22600223)
    e3:SetCondition(c22600222.dcon)
    e3:SetTarget(c22600222.dtg)
    e3:SetOperation(c22600222.dop)
    c:RegisterEffect(e3)
end
function c22600222.spfilter(c,e,tp)
    return c:IsSetCard(0x262) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c22600222.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c22600222.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c22600222.tdfilter(c)
    return c:IsSetCard(0x262) and c:IsAbleToDeck()
end
function c22600222.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
    Duel.ConfirmDecktop(tp,1)
    Duel.BreakEffect()
    local g=Duel.GetDecktopGroup(tp,1)
    local tc=g:GetFirst()
    if tc:IsSetCard(0x262) and Duel.IsExistingMatchingCard(c22600222.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg1=Duel.SelectMatchingCard(tp,c22600222.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
        if sg1:GetCount()>0 then
            Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)
        end
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local sg2=Duel.SelectMatchingCard(tp,c22600222.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
        if sg2:GetCount()>0 then
            Duel.SendtoDeck(sg2,tp,2,REASON_EFFECT)
        end
    end
    Duel.BreakEffect()
    Duel.ShuffleDeck(tp)
end
function c22600222.dcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
function c22600222.filter(c)
    return c:IsType(TYPE_LINK)
end
function c22600222.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(c22600222.cfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    local x=g:GetSum(Card.GetLink)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
        and Duel.IsPlayerCanDiscardDeck(tp,x) end
end
function c22600222.dop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c22600222.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    local x=g:GetSum(Card.GetLink)
    Duel.ConfirmDecktop(tp,x)
    Duel.BreakEffect()
    local sx=Duel.GetDecktopGroup(tp,x)
    if sx:GetCount()>0 then
        Duel.DisableShuffleCheck()
        if sx:IsExists(Card.IsSetCard,1,nil,0x262) then
            local ct=sx:FilterCount(Card.IsSetCard,nil,0x262)
            Duel.Damage(1-tp,ct*300,REASON_EFFECT)
        end
    end
    Duel.BreakEffect()
    Duel.ShuffleDeck(tp)
end