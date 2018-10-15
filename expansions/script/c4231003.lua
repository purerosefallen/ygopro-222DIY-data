--奇迹的巧合-库洛伊
local m=4231003
local cm=_G["c"..m]
function cm.initial_effect(c)
    iFunc(c).c("RegisterEffect",iFunc(c)
        .e("SetCategory",CATEGORY_SPECIAL_SUMMON)
        .e("SetType",EFFECT_TYPE_IGNITION)
        .e("SetRange",LOCATION_HAND)
        .e("SetCost",function(e,tp,eg,ep,ev,re,r,rp,chk) 
            if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
            Duel.DiscardHand(tp,cm.costfilter,1,1,REASON_COST+REASON_DISCARD)
        end)
        .e("SetTarget",function(e,tp,eg,ep,ev,re,r,rp,chk)
            if chk==0 then return iCount(0,tp,m,1)                 
                and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) 
                and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
            Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)         
        end)
        .e("SetOperation",function(e,tp,eg,ep,ev,re,r,rp)
            if e:GetHandler():IsLocation(LOCATION_HAND) then
                if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil)then
                    if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
                        local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
                        Duel.SendtoHand(g,nil,REASON_EFFECT)
                        Duel.ConfirmCards(1-tp,g)
                    end
                end                
            end            
        end)
    .Return()).c("RegisterEffect",iFunc(c)
        .e("SetCategory",CATEGORY_SPECIAL_SUMMON)
        .e("SetType",EFFECT_TYPE_IGNITION)
        .e("SetRange",LOCATION_MZONE)
        .e("SetProperty",EFFECT_FLAG_CARD_TARGET)
        .e("SetCost",function(e,tp,eg,ep,ev,re,r,rp,chk) 
            if chk==0 then return Duel.CheckReleaseGroup(tp,cm.relfilter,1,nil,tp) end
            local g=Duel.SelectReleaseGroup(tp,cm.relfilter,1,1,nil,tp)
            Duel.Release(g,REASON_COST) end)
        .e("SetTarget",function(e,tp,eg,ep,ev,re,r,rp,chk) 
            if chk==0 then return iCount(0,tp,m,2) and Duel.IsExistingMatchingCard(cm.deckfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
            Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK) end)
        .e("SetOperation",function(e,tp,eg,ep,ev,re,r,rp) 
            if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local g=Duel.SelectMatchingCard(tp,cm.deckfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
            if g:GetCount()>0 then
                Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
            end end)
    .Return())
end
function cm.deckfilter(c,e,tp)
    return (c:IsCode(4231001) or c:IsCode(4231002)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.relfilter(c,tp)
    return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_NORMAL) and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.costfilter(c)
    return c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function cm.thfilter(c) 
    return (c:IsCode(4231004) or c:IsCode(4231005)) and c:IsAbleToHand() 
end
function iCount(name,tp,m,id)
    return ((name=="get" or name=="set")
        and {(name=="get"
            and {tonumber(((Duel.GetFlagEffect(tp,m)==nil) and {0} or {Duel.GetFlagEffect(tp,m)})[1])} 
            or { Debug.Message("","请使用Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)") })[1]}
        or {(bit.band(iCount("get",tp,m,id),math.pow(2,id-1))==0 and {true} or {false})[1]})[1]
end
function iFunc(c,x)
    local __this = (aux.GetValueType(c) == "Card" and {(x == nil and {Effect.CreateEffect(c)} or {x})[1]} or {x})[1] 
    local fe = function(name,...) (type(__this[name])=="function" and {__this[name]} or {""})[1](__this,...) return iFunc(c,__this) end
    local fc = function(name,...) this = (type(c[name])=="function" and {c[name]} or {""})[1](c,...) return iFunc(c,c) end  
    local func ={e = fe,c = fc,g = fc,v = function() return this end,Return = function() return __this:Clone() end}
    return func
end