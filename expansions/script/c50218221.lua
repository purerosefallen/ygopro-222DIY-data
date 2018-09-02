--T·F Revenge Of The Fallen
function c50218221.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_BATTLE_DESTROYED)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1,50218221)
    e2:SetTarget(c50218221.target)
    e2:SetOperation(c50218221.activate)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_DESTROYED)
    c:RegisterEffect(e3)
end
function c50218221.filter(c,e,tp)
    return c:IsSetCard(0xcb2) and c:IsLocation(LOCATION_GRAVE) and c:IsCanBeEffectTarget(e)
        and c:GetPreviousControler()==tp and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end
function c50218221.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return eg:IsContains(chkc) and c50218221.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and eg:IsExists(c50218221.filter,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=eg:FilterSelect(tp,c50218221.filter,1,1,nil,e,tp)
    Duel.SetTargetCard(g)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c50218221.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
    end
end