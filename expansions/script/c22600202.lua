--占星少女  忒瑞丝
function c22600202.initial_effect(c)
    --draw
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,22600202)
    e1:SetTarget(c22600202.target)
    e1:SetOperation(c22600202.operation)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)

    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCountLimit(1,22600203)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTarget(c22600202.sptg)
    e3:SetOperation(c22600202.spop)
    c:RegisterEffect(e3)
end

function c22600202.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function c22600202.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    if Duel.Draw(p,d,REASON_EFFECT)==0 then return end
    Duel.BreakEffect()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.BreakEffect()
        Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
    end
end

function c22600202.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function c22600202.spop(e,tp,eg,ep,ev,re,r,rp)
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