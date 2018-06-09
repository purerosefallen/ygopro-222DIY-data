--占星少女  赛吉泰瑞尔
function c22600214.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c22600214.matfilter,1,1)

    --
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetValue(c22600214.linklimit)
    c:RegisterEffect(e1)

    --todeck
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,22600214)
    e2:SetCondition(c22600214.dcon)
    e2:SetTarget(c22600214.dtg)
    e2:SetOperation(c22600214.dop)
    c:RegisterEffect(e2)

    --todeck
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(c22600214.tdcon)
    e3:SetTarget(c22600214.tdtg)
    e3:SetOperation(c22600214.tdop)
    c:RegisterEffect(e3)
end

function c22600214.matfilter(c)
    return c:IsLinkSetCard(0x262) and c:IsLinkType(TYPE_LINK)
end

function c22600214.linklimit(e,c)
    if not c then return false end
    return not c:IsSetCard(0x262)
end

function c22600214.dcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

function c22600214.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)>0 end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_ONFIELD)
end

function c22600214.dop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)==0 then return end
    Duel.ConfirmDecktop(tp,1)
    Duel.BreakEffect()
    local g=Duel.GetDecktopGroup(tp,1)
    local tc=g:GetFirst()
    if tc:IsSetCard(0x262) then
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22600214,0))
        local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
        Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
    else
        Duel.SendtoDeck(tc,tp,2,REASON_EFFECT)
    end
end

function c22600214.tdcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

function c22600214.tdfilter(c,e,tp)
    return c:IsSetCard(0x262) and c:IsAbleToDeck()
end

function c22600214.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c22600214.tdfilter(chkc,e,tp) end
    if chk==0 then return Duel.IsExistingTarget(c22600214.tdfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c22600214.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end

function c22600214.tdop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.SendtoDeck(tc,tp,0,REASON_EFFECT)
    end
end
