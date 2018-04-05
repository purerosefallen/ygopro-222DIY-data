--神之力
function c5012617.initial_effect(c)
    c:SetSPSummonOnce(5012617)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,c5012617.fsfilter,3,true)
    --special summon rule
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(c5012617.sprcon)
    e1:SetOperation(c5012617.sprop)
    c:RegisterEffect(e1)
    --sp
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCondition(c5012617.con)
    e2:SetTarget(c5012617.sptg)
    e2:SetOperation(c5012617.spop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_REMOVE)
    c:RegisterEffect(e3)
    local e4=e2:Clone()
    e4:SetCode(EVENT_TO_DECK)
    c:RegisterEffect(e4)
    --change
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(5012617,1))
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetRange(LOCATION_MZONE)
    e5:SetHintTiming(0,0x1e0)
    e5:SetCountLimit(1)
    e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e5:SetTarget(c5012617.chtg)
    e5:SetOperation(c5012617.chop)
    c:RegisterEffect(e5)
    --lp
    local e11=Effect.CreateEffect(c)
    e11:SetDescription(aux.Stringid(5012617,0))
    e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e11:SetCode(5012617)
    e11:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e11:SetRange(LOCATION_MZONE)
    e11:SetCondition(c5012617.lpcon)
    e11:SetCost(c5012617.lpcost)
    e11:SetOperation(c5012617.lpop)
    c:RegisterEffect(e11)
end
function c5012617.fsfilter(c)
    return c:IsSetCard(0x250) and not c:IsType(TYPE_TUNER)
end

function c5012617.con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c5012617.spfilter(c,e,tp)
    return c:IsSetCard(0x250) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c5012617.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
    and Duel.IsExistingMatchingCard(c5012617.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)  end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c5012617.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c5012617.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then  
    Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP) 
end
end
function c5012617.code(c)
    return  not c:IsCode(5012619) and c:IsFaceup()
end
function c5012617.chtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(c5012617.code,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectTarget(tp,c5012617.code,tp,LOCATION_MZONE,LOCATION_MZONE,2,2,nil)
     Duel.HintSelection(g)
     Duel.SetChainLimit(c5012617.chainlimit)
end
function c5012617.chainlimit(e,rp,tp)
    return  not e:IsActiveType(TYPE_MONSTER+TYPE_TRAP)
end
function c5012617.lpfilter(c)
    return c:GetCode()==5012619 and c:IsFaceup()
end
function c5012617.chop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local tc=g:Filter(Card.IsRelateToEffect,nil,e)
    local tg=tc:GetFirst() 
    while tg do
    if tg:IsFaceup() then
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CHANGE_CODE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetValue(5012619)
    e1:SetReset(RESET_EVENT+0xfe0000)
    tg:RegisterEffect(e1)
    end
   tg=tc:GetNext()
   if Duel.GetMatchingGroupCount(c5012617.lpfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)>=5 then   
   Duel.RaiseEvent(e:GetHandler(),5012617,e,0,0,0,0)
   end
   end
end
function c5012617.lpcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetCode()==5012617 
end
function c5012617.lpcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
    Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c5012617.lpop(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetLP(tp,1)
    Duel.SetLP(1-tp,1)
end

function c5012617.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.IsExistingMatchingCard(c5012617.sprfilter1,tp,LOCATION_MZONE,0,1,nil,tp,c)
end
function c5012617.sprfilter1(c,tp,fc)
    return c:IsFusionSetCard(0x250) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(fc) and not c:IsType(TYPE_TUNER)
        and Duel.IsExistingMatchingCard(c5012617.sprfilter2,tp,LOCATION_MZONE,0,1,c,tp,fc,c)
end
function c5012617.sprfilter2(c,tp,fc,mc)
    local g=Group.FromCards(c,mc)
    return c:IsFusionSetCard(0x250) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(fc) and Duel.IsExistingMatchingCard(c5012617.sprfilter3,tp,LOCATION_MZONE,0,1,g,tp,fc,mc,c) and not c:IsType(TYPE_TUNER)
end
function c5012617.sprfilter3(c,tp,fc,mc1,mc2)
    local g=Group.FromCards(c,mc1,mc2)
    return c:IsFusionSetCard(0x250) and not c:IsType(TYPE_TUNER) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(fc) and Duel.GetLocationCountFromEx(tp,tp,g)>0
end
function c5012617.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g1=Duel.SelectMatchingCard(tp,c5012617.sprfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g2=Duel.SelectMatchingCard(tp,c5012617.sprfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),tp,c,g1:GetFirst())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g3=Duel.SelectMatchingCard(tp,c5012617.sprfilter3,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),tp,c,g1:GetFirst(),g2:GetFirst())
    g1:Merge(g2)
    g1:Merge(g3)
    Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
