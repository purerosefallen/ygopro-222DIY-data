--纯粹的疯狂
local m=2111007
local cm=_G["c"..m]
function cm.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,2111007+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(c2111007.condition)
    e1:SetTarget(c2111007.tg)
    e1:SetOperation(c2111007.op)
    c:RegisterEffect(e1)
    --tohand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(2111007,1))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCountLimit(1,2111107)
    e2:SetCondition(c2111007.thcon)
    e2:SetCost(c2111007.cost1)
    e2:SetTarget(c2111007.thtg)
    e2:SetOperation(c2111007.thop)
    c:RegisterEffect(e2)
end
c2111007.card_code_list={2111001}
function c2111007.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetLP(tp)<=4000
end
function c2111007.filter(c,e,tp)
    return c:IsSetCard(0x218) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c2111007.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
        and Duel.IsExistingMatchingCard(c2111007.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c2111007.op(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local tg=Duel.GetMatchingGroup(c2111007.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
    if ft<=0 then return end
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
    local g=nil
    if tg:GetCount()>ft then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        g=tg:Select(tp,ft,ft,nil)
    else
        g=tg
    end
    if g:GetCount()>0 then
        local fid=e:GetHandler():GetFieldID()
        local tc=g:GetFirst()
        while tc do
            Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
            tc:RegisterFlagEffect(2111007,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
            tc=g:GetNext()
        end
        Duel.SpecialSummonComplete()
        g:KeepAlive()
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e1:SetReset(RESET_PHASE+PHASE_END)
        e1:SetCountLimit(1)
        e1:SetLabel(fid)
        e1:SetLabelObject(g)
        e1:SetCondition(c2111007.rmcon)
        e1:SetOperation(c2111007.rmop)
        Duel.RegisterEffect(e1,tp)
    end
end
function c2111007.rmfilter(c,fid)
    return c:GetFlagEffectLabel(2111007)==fid
end
function c2111007.rmcon(e,tp,eg,ep,ev,re,r,rp)
    local g=e:GetLabelObject()
    if not g:IsExists(c2111007.rmfilter,1,nil,e:GetLabel()) then
        g:DeleteGroup()
        e:Reset()
        return false
    else return true end
end
function c2111007.rmop(e,tp,eg,ep,ev,re,r,rp)
    local g=e:GetLabelObject()
    local tg=g:Filter(c2111007.rmfilter,nil,e:GetLabel())
    g:DeleteGroup()
    Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end
function c2111007.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_EFFECT)
end
function c2111007.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c2111007.thfilter(c)
    return c:IsSetCard(0x218) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c2111007.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c2111007.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c2111007.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c2111007.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end