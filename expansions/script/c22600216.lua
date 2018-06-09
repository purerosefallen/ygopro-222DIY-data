--占星少女  埃克蕾恩
function c22600216.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x262),2)
    c:EnableReviveLimit()
    --specialsummon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(c22600216.cost)
    e1:SetCountLimit(1,22600216)
    e1:SetTarget(c22600216.target)
    e1:SetOperation(c22600216.operation)
    c:RegisterEffect(e1)
    --todeck
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    e2:SetTarget(c22600216.dtg)
    e2:SetOperation(c22600216.dop)
    c:RegisterEffect(e2)
    --todeck
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(c22600216.tdcon)
    e3:SetTarget(c22600216.tdtg)
    e3:SetOperation(c22600216.tdop)
    c:RegisterEffect(e3)
end
function c22600216.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetCustomActivityCount(22600216,tp,ACTIVITY_SPSUMMON)==0 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c22600216.limit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c22600216.limit(e,c,sump,sumtype,sumpos,targetp,se)
    return not c:IsSetCard(0x262) and c:IsLocation(LOCATION_EXTRA)
end
function c22600216.filter1(c,link)
    return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsLinkBelow(link)
end
function c22600216.tfilter(c,e,tp)
    return c:IsSetCard(0x262) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c22600216.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22600216.filter1(chkc) end
    if chk==0 then return Duel.IsExistingMatchingCard(c22600216.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tc) and Duel.IsExistingMatchingCard(c22600216.tfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22600216,0))
    Duel.SelectTarget(tp,c22600216.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tc)
end
function c22600216.filter(c)
    return c:IsSetCard(0x262)
end
function c22600216.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    local l=tc:GetLink()
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if not Duel.IsPlayerCanDiscardDeck(tp,l) then return end
    Duel.ConfirmDecktop(tp,l)
    Duel.BreakEffect()
    local g=Duel.GetDecktopGroup(tp,l)
    local ct=g:FilterCount(c22600216.filter,nil)
    local sg=Duel.GetMatchingGroup(c22600216.tfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
    if ct>0 and ft>0 and sg:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local ssg=sg:Select(tp,1,1,nil)
        sg:Remove(Card.IsCode,nil,ssg:GetFirst():GetCode())
        if not Duel.IsPlayerAffectedByEffect(tp,59822133) then
            ft=ft-1
            ct=ct-1
            while ft>0 and ct>0 and sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(22600216,2)) do
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
                local sg2=sg:Select(tp,1,1,nil)
                ssg:AddCard(sg2:GetFirst())
                sg:Remove(Card.IsCode,nil,sg2:GetFirst():GetCode())
                ft=ft-1
                ct=ct-1
            end
        end
        local t=ssg:GetFirst()
        while t do
            Duel.SpecialSummonStep(t,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_DISABLE)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            t:RegisterEffect(e1)
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_DISABLE_EFFECT)
            e2:SetReset(RESET_EVENT+0x1fe0000)
            t:RegisterEffect(e2)
            t:RegisterFlagEffect(22600216,RESET_EVENT+0x1fe0000,0,1,fid)
            t=ssg:GetNext()
        end
        Duel.SpecialSummonComplete()
        Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
        Duel.BreakEffect()
        Duel.ShuffleDeck(tp)
    end
end
function c22600216.dcfilter(c,e)
    return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)
end
function c22600216.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return eg:IsContains(chkc) and c22600216.dcfilter(chkc,e) end
    if chk==0 then return eg:IsExists(c22600216.dcfilter,1,nil,e) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=eg:FilterSelect(tp,c22600216.dcfilter,1,1,nil,e)
    Duel.SetTargetCard(g)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c22600216.dop(e,tp,eg,ep,ev,re,r,rp)
   local tc=Duel.GetFirstTarget()
   if tc:IsRelateToEffect(e) then
        Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
   end
end
function c22600216.tdcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

function c22600216.tdfilter(c,e,tp)
    return c:IsSetCard(0x262) and c:IsAbleToDeck()
end

function c22600216.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c22600216.tdfilter(chkc,e,tp) end
    if chk==0 then return Duel.IsExistingTarget(c22600216.tdfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c22600216.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end

function c22600216.tdop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.SendtoDeck(tc,tp,0,REASON_EFFECT)
    end
end