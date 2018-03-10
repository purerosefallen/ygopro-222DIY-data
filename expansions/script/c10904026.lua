--小憩的灵刻使
local m=10904026
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(cm.con)
    e1:SetTarget(cm.thtg)
    e1:SetOperation(cm.thop)
    c:RegisterEffect(e1)      
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCondition(cm.con2)
    e3:SetCost(aux.bfgcost)
    e3:SetTarget(cm.seqtg)
    e3:SetOperation(cm.seqop)
    c:RegisterEffect(e3) 
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOHAND)
    e4:SetDescription(aux.Stringid(31423101,0))
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_REMOVED)
    e4:SetCountLimit(1,m)
    e4:SetCondition(cm.thcon)
    e4:SetTarget(cm.thtg2)
    e4:SetOperation(cm.thop2)
    c:RegisterEffect(e4)
end
function cm.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x237) and c:IsType(TYPE_SYNCHRO)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.thfilter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function cm.filter2(c)
    return c:IsFaceup() and c:IsSetCard(0x237) and (c:IsType(TYPE_XYZ) or c:IsType(TYPE_FUSION))
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_MZONE,0,1,nil)
end
function cm.seqfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x237)
end
function cm.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.seqfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.seqfilter,tp,LOCATION_MZONE,0,1,nil) 
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(92204263,1))
    Duel.SelectTarget(tp,cm.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.seqop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,571)
    local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
    local nseq=math.log(s,2)
    Duel.MoveSequence(tc,nseq)
end
function cm.filter3(c)
    return c:IsFaceup() and c:IsSetCard(0x237) and c:IsType(TYPE_LINK)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_MZONE,0,1,nil)
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,c)
    end
end
