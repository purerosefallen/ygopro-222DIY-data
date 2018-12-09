--护国真龙 斯卡哈
function c47510269.initial_effect(c)
    --revive limit
    aux.EnableReviveLimitPendulumSummonable(c,LOCATION_HAND+LOCATION_EXTRA)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --special summon condition
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e0)  
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_DECK)
    e1:SetCondition(c47510269.spcon)
    e1:SetOperation(c47510269.spop)
    c:RegisterEffect(e1)  
    --spsummon limit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetOperation(c47510269.regop)
    c:RegisterEffect(e2)
    --effect
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47510269,0))
    e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCountLimit(1,47510269)
    e3:SetCondition(c47510269.tfcon)
    e3:SetTarget(c47510269.tftg)
    e3:SetOperation(c47510269.tfop)
    c:RegisterEffect(e3)
    --rehand
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47510269,2))
    e4:SetCategory(CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_LEAVE_FIELD)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetRange(LOCATION_EXTRA)
    e4:SetCountLimit(1,47510269)
    e4:SetCondition(c47510269.thcon)
    e4:SetTarget(c47510269.thtg)
    e4:SetOperation(c47510269.thop)
    c:RegisterEffect(e4)
    --splimit
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetRange(LOCATION_PZONE)
    e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e5:SetTargetRange(1,0)
    e5:SetTarget(c47510269.splimit1)
    c:RegisterEffect(e5) 
    --to hand
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(47510269,1))
    e6:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e6:SetRange(LOCATION_PZONE)
    e6:SetCountLimit(1,47510270)
    e6:SetCost(c47510269.descost)
    e6:SetTarget(c47510269.destg)
    e6:SetOperation(c47510269.desop)
    c:RegisterEffect(e6)
    Duel.AddCustomActivityCounter(47510269,ACTIVITY_SPSUMMON,c47510269.counterfilter)
end
function c47510269.counterfilter(c)
    return c:IsType(TYPE_PENDULUM)
end
function c47510269.splimit1(e,c,tp,sumtp,sumpos)
    return not c:IsType(TYPE_PENDULUM)
end
function c47510269.rfilter(c,tp)
    return c:IsType(TYPE_PENDULUM) and (c:IsControler(tp) or c:IsFaceup())
end
function c47510269.mzfilter(c,tp)
    return c:IsControler(tp) and c:GetSequence()<5
end
function c47510269.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local rg=Duel.GetReleaseGroup(tp):Filter(c47510269.rfilter,nil,tp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local ct=-ft+1
    return ft>-2 and rg:GetCount()>1 and (ft>0 or rg:IsExists(c47510269.mzfilter,ct,nil,tp))
end
function c47510269.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local rg=Duel.GetReleaseGroup(tp):Filter(c47510269.rfilter,nil,tp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local g=nil
    if ft>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        g=rg:Select(tp,3,3,nil)
    elseif ft==0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        g=rg:FilterSelect(tp,c47510269.mzfilter,3,3,nil,tp)
    end
    Duel.Release(g,REASON_COST)
end
function c47510269.regop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47510269.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c47510269.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return not c:IsType(TYPE_PENDULUM)
end
function c47510269.tfcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function c47510269.tffilter(c)
    return not c:IsForbidden() and c:IsType(TYPE_PENDULUM)
end
function c47510269.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47510269.tffilter,tp,LOCATION_DECK,0,1,nil) end
end
function c47510269.tfop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47510269.tffilter,tp,LOCATION_DECK,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
        e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetRange(LOCATION_SZONE)
        e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
        e2:SetCode(EFFECT_LINK_SPELL_KOISHI)
        e2:SetValue(LINK_MARKER_TOP+LINK_MARKER_TOP_LEFT+LINK_MARKER_TOP_RIGHT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
        tc:RegisterEffect(e2)
    end
end
function c47510269.drcfilter(c,tp)
    return c:IsPreviousLocation(LOCATION_PZONE) and c:GetPreviousControler()==tp
end
function c47510269.thcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c47510269.drcfilter,1,nil,tp)
end
function c47510269.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c47510269.drcfilter,1,nil,tp) end
    local g=eg:Filter(c47510269.drcfilter,nil,tp)
    Duel.SetTargetCard(g)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA+LOCATION_DECK)
end
function c47510269.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=eg:Filter(c47510269.drcfilter,nil,tp)
    if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
        e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
        c:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetRange(LOCATION_SZONE)
        e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
        e2:SetCode(EFFECT_LINK_SPELL_KOISHI)
        e2:SetValue(LINK_MARKER_TOP+LINK_MARKER_TOP_LEFT+LINK_MARKER_TOP_RIGHT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
        c:RegisterEffect(e2)
    end
end
function c47510269.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetCustomActivityCount(47510269,tp,ACTIVITY_SPSUMMON)==0 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47510269.splimit)
    Duel.RegisterEffect(e1,tp)
end
function c47510269.splimit2(e,c,sump,sumtype,sumpos,targetp,se)
    return not c:IsType(TYPE_PENDULUM)
end
function c47510269.thfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c47510269.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc:IsFaceup() and chkc~=c end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,c)
        and Duel.IsExistingMatchingCard(c47510269.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_ONFIELD,0,1,1,c,TYPE_PENDULUM)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c47510269.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,c47510269.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.BreakEffect()
            Duel.SendtoHand(g,tp,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
        local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_PZONE,nil)
        local tc=g1:GetFirst()
        local c=e:GetHandler()
        while tc do
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetCode(EFFECT_CHANGE_TYPE)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
            e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
            tc:RegisterEffect(e1)
            local e2=Effect.CreateEffect(e:GetHandler())
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetRange(LOCATION_SZONE)
            e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
            e2:SetCode(EFFECT_LINK_SPELL_KOISHI)
            e2:SetValue(LINK_MARKER_TOP+LINK_MARKER_TOP_LEFT+LINK_MARKER_TOP_RIGHT)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
            tc:RegisterEffect(e2)
            tc=g:GetNext()
        end
    end
end