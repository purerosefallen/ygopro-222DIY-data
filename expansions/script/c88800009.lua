--Divina, Shadow of the Dragonlords
--Delivery
local card = c88800009
local id=88800009
function card.initial_effect(c)
    --You can only control 1
    c:SetUniqueOnField(1,0,id)
    --Special Summon from Hand during either player's turn.
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_HAND)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetCondition(card.hspcon)
    e1:SetOperation(card.hspop)
    c:RegisterEffect(e1)
    --Special Summon from Hand or GY if a "Dragonlord" card is Tributed during opponent's turn.
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1)
    e2:SetCondition(card.spcon)
    e2:SetTarget(card.sptg)
    e2:SetOperation(card.spop)
    c:RegisterEffect(e2)
    --Cannot be Targeted by card effects.
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(aux.tgoval)
    c:RegisterEffect(e3)
    --While Face-Up cannot be tributed for a Tribute Summon (E4) or anything else (E5)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_UNRELEASABLE_SUM)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
    c:RegisterEffect(e5)
end
--------------------------------------------------
--Special Summon from hand  (Unbugged   6/10/18)
--------------------------------------------------
--Special Summon from hand during Main Phase Condition (what needs to be there).
function card.hspcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    return ft>-1 and Duel.CheckReleaseGroup(tp,card.hspfilter,1,nil,ft,tp)
end
--Special Summon from hand during Main Phase operation (what it actually does).
function card.hspop(e,tp,eg,ep,ev,re,r,rp,c)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local g=Duel.SelectReleaseGroup(tp,card.hspfilter,1,1,nil,ft,tp)
    Duel.Release(g,REASON_COST)
    c:RegisterFlagEffect(0,RESET_EVENT+0x4fc0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
end
--------------------------------------------------
--Special Summon from GY   (Unbugged(?) 6/10/18)
---------------------------------------------------
--Condition Is it your opponent's turn, was a monster sent and if it was, was it this card.
function card.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp and not eg:IsContains(e:GetHandler()) and eg:IsExists(card.spcfilter,1,nil,tp)
end
--Sets the operation to Special Summon for itself and the whole effect.
function card.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
--Activates the effect to Special Summon it from the GY.
function card.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end
----------------------------------------------------
--Filters
----------------------------------------------------
--Is its a Dracolord Monster...and...something else im not sure of, you can probably delete it? w/e basically saying, is a "Dragonlord" monster you control and something about a sequence, no clue here.
function card.hspfilter(c,ft,tp)
    return c:IsSetCard(0xfb0)
        and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
-- Checking to see who controlled the sent "Dragonlord" Monster, where it was sent from and whether or not it was a "Dragonlord" Monster at all.
function card.spcfilter(c,tp)
    return c:GetPreviousControler()==tp and c:IsSetCard(0xfb0) and c:IsType(TYPE_MONSTER)
end
