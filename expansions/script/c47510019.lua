--雷鸣的星晶兽 巴尔
function c47510019.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --tograve
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,47510019)
    e2:SetTarget(c47510019.thtg)
    e2:SetOperation(c47510019.thop)
    c:RegisterEffect(e2) 
    --synchro limit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e3:SetValue(c47510019.synlimit)
    c:RegisterEffect(e3)
    --serch
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_SUMMON_SUCCESS)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCountLimit(1,47510020)
    e4:SetTarget(c47510019.tetg)
    e4:SetOperation(c47510019.teop)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e5)
    --summoneffect
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_EXTRA)
    e6:SetCode(EVENT_FREE_CHAIN)
    e6:SetCountLimit(1,47510000)
    e6:SetCost(c47510019.cost)
    e6:SetOperation(c47510019.op)
    c:RegisterEffect(e6)
    c47510019.ss_effect=e6
    --synchro level
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCode(EFFECT_SYNCHRO_LEVEL)
    e7:SetValue(c47510019.slevel)
    c:RegisterEffect(e7) 
end
function c47510019.IsGran(c)
    local m=_G["c"..c:GetCode()]
    return m and m.is_named_with_Ma_Elf 
end
function c47510019.slevel(e,c)
    local lv=e:GetHandler():GetLevel()
    return 1*65536+lv
end
function c47510019.pefilter(c)
    return c:IsRace(RACE_ROCK) or c:IsSetCard(0x5da) or c:IsAttribute(ATTRIBUTE_EARTH)
end
function c47510019.psplimit(e,c,tp,sumtp,sumpos)
    return not c47510019.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47510019.filter(c)
    return c:IsAbleToGrave() and (c:IsSetCard(0x5d0) or c:IsSetCard(0x5da) or c:IsSetCard(0x5de) or c:IsSetCard(0x5d3) or aux.IsCodeListed(c,47500000) or c:IsSetCard(0x813) or c47510019.IsGran(c))
end
function c47510019.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_DECK) and c47510019.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c47510019.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectTarget(tp,c47510019.filter,tp,LOCATION_DECK,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c47510019.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local sg=g:Filter(Card.IsRelateToEffect,nil,e)
    if sg:GetCount()>0 then
        Duel.SendtoGrave(sg,nil,REASON_EFFECT)
    end
end
function c47510019.synlimit(e,c)
    if not c then return false end
    return not c:IsAttribute(ATTRIBUTE_EARTH) or c:IsSetCard(0x5da)
end
function c47510019.tefilter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x5da) and not c:IsForbidden()
end
function c47510019.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47510019.tefilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,2,tp,LOCATION_GRAVE)
end
function c47510019.teop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(47510019,3))
    local g=Duel.SelectMatchingCard(tp,c47510019.tefilter,tp,LOCATION_GRAVE,0,1,2,nil)
    if g:GetCount()>0 then
        Duel.SendtoExtraP(g,tp,REASON_EFFECT)
    end
end
function c47510019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c47510019.filter1(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH) or c:IsSetCard(0x5da)
end
function c47510019.op(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_MZONE)
    e1:SetOperation(c47510019.chainop)
    Duel.RegisterEffect(e1,tp)
end
function c47510019.chainop(e,tp,eg,ep,ev,re,r,rp)
    if re:GetHandler():IsType(TYPE_PENDULUM) and ep==tp then
        Duel.SetChainLimit(c47510019.chainlm)
    end
end
function c47510019.chainlm(e,rp,tp)
    return tp==rp
end