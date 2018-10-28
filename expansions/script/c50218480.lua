--Assemble of Avengers
function c50218480.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --atk up
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetCondition(c50218480.atkcon)
    e2:SetTarget(c50218480.atktg)
    e2:SetValue(c50218480.atkval)
    c:RegisterEffect(e2)
    --move
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(50218480,0))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(c50218480.mvtg)
    e3:SetOperation(c50218480.mvop)
    c:RegisterEffect(e3)
    --todeck
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(50218480,1))
    e4:SetCategory(CATEGORY_TODECK)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCountLimit(1)
    e4:SetTarget(c50218480.tdtg)
    e4:SetOperation(c50218480.tdop)
    c:RegisterEffect(e4)
end
function c50218480.atkcon(e)
    c50218480[0]=false
    return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and Duel.GetAttackTarget()
end
function c50218480.atktg(e,c)
    return c==Duel.GetAttacker() and c:IsSetCard(0xcb4)
end
function c50218480.atkval(e,c)
    local d=Duel.GetAttackTarget()
    if c50218480[0] or c:GetAttack()<d:GetAttack() then
        c50218480[0]=true
        return 1000
    else return 0 end
end
function c50218480.mvfilter1(c)
    return c:IsFaceup() and c:IsSetCard(0xcb4)
end
function c50218480.mvfilter2(c,tp)
    return c:IsFaceup() and c:IsSetCard(0xcb4) and c:GetSequence()<5
        and Duel.IsExistingMatchingCard(c50218480.mvfilter3,tp,LOCATION_MZONE,0,1,c)
end
function c50218480.mvfilter3(c)
    return c:IsFaceup() and c:IsSetCard(0xcb4) and c:GetSequence()<5
end
function c50218480.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local b1=Duel.IsExistingMatchingCard(c50218480.mvfilter1,tp,LOCATION_MZONE,0,1,nil)
        and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0
    local b2=Duel.IsExistingMatchingCard(c50218480.mvfilter2,tp,LOCATION_MZONE,0,1,nil,tp)
    if chk==0 then return b1 or b2 end
    local op=0
    if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(50218480,2),aux.Stringid(50218480,3))
    elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(50218480,2))
    else op=Duel.SelectOption(tp,aux.Stringid(50218480,3))+1 end
    e:SetLabel(op)
end
function c50218480.mvop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if e:GetLabel()==0 then
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(50218480,4))
        local g=Duel.SelectMatchingCard(tp,c50218480.mvfilter1,tp,LOCATION_MZONE,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
            local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
            local nseq=math.log(s,2)
            Duel.MoveSequence(g:GetFirst(),nseq)
        end
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
        local g1=Duel.SelectMatchingCard(tp,c50218480.mvfilter2,tp,LOCATION_MZONE,0,1,1,nil,tp)
        local tc1=g1:GetFirst()
        if not tc1 then return end
        Duel.HintSelection(g1)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
        local g2=Duel.SelectMatchingCard(tp,c50218480.mvfilter3,tp,LOCATION_MZONE,0,1,1,tc1)
        Duel.HintSelection(g2)
        local tc2=g2:GetFirst()
        Duel.SwapSequence(tc1,tc2)
    end
end
function c50218480.tdfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c50218480.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c50218480.tdfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c50218480.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c50218480.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c50218480.tdop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
    end
end