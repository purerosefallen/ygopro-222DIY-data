--占星少女的星空图
function c22600218.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --atkup
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x262))
    e2:SetValue(c22600218.val)
    c:RegisterEffect(e2)
    --
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(c22600218.target)
    e3:SetOperation(c22600218.operation)
    c:RegisterEffect(e3)
    --search
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_PREDRAW)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCondition(c22600218.con)
    e4:SetTarget(c22600218.tg)
    e4:SetOperation(c22600218.op)
    c:RegisterEffect(e4)
end
function c22600218.atkfilter(c)
    return c:IsType(TYPE_LINK)
end
function c22600218.val(e,c)
    local g=Duel.GetMatchingGroup(c22600218.atkfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)
    return g:GetSum(Card.GetLink)*100
end
function c22600218.filter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x262)
end
function c22600218.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c22600218.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c22600218.operation(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22600218,0))
    local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK,0,1,1,nil,0x262)
    local tc=g:GetFirst()
    if tc then
        Duel.ShuffleDeck(tp)
        Duel.MoveSequence(tc,0)
        Duel.ConfirmDecktop(tp,1)
    end
end
function c22600218.con(e,tp,eg,ep,ev,re,r,rp)
    return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
        and Duel.GetDrawCount(tp)>0
end
function c22600218.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
    local dt=Duel.GetDrawCount(tp)
    if dt~=0 then
        _replace_count=0
        _replace_max=dt
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetCode(EFFECT_DRAW_COUNT)
        e1:SetTargetRange(1,0)
        e1:SetReset(RESET_PHASE+PHASE_DRAW)
        e1:SetValue(0)
        Duel.RegisterEffect(e1,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c22600218.op(e,tp,eg,ep,ev,re,r,rp)
    _replace_count=_replace_count+1
    if _replace_count>_replace_max or not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
    if g:GetCount()>0 then
        local tg=g:GetMinGroup(Card.GetSequence):GetFirst()
        Duel.DisableShuffleCheck()
        Duel.SendtoHand(tg,nil,REASON_EFFECT)
    end
end