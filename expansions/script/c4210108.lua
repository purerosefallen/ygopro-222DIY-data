--妮娜与莉昂的学园生活
function c4210108.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(4210108,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetCountLimit(1,4210108)
    e1:SetCondition(c4210108.condition)
    e1:SetTarget(c4210108.target)
    e1:SetOperation(c4210108.operation)
    c:RegisterEffect(e1)
    --return tohand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(4210108,1))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetTarget(c4210108.tg)
    e2:SetOperation(c4210108.op)
    c:RegisterEffect(e2)
end
function c4210108.cfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c4210108.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c4210108.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c4210108.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c4210108.operation(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsExistingMatchingCard(c4210108.cfilter,tp,LOCATION_MZONE,0,1,nil) then return end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x47e0000)
        e1:SetValue(LOCATION_REMOVED)
        c:RegisterEffect(e1,true)
    end
end
function c4210108.filter(c,g)
    return g:IsContains(c) and c:IsAbleToHand()
end
function c4210108.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    local cg=e:GetHandler():GetColumnGroup()
    if chkc then return chkc:IsOnField() and c4210108.filter(chkc,cg) end
    if chk==0 then return Duel.IsExistingTarget(c4210108.filter,tp,0,LOCATION_ONFIELD,1,nil,cg) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectTarget(tp,c4210108.filter,tp,0,LOCATION_MZONE,1,1,nil,cg)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c4210108.op(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end