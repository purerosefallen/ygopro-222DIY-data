local m=77709001
local cm=_G["c"..m]
xpcall(function() require("expansions/script/lap") end,function() require("expansions/sekka1217/script/lap") end)
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Sekka_name_with_lap=true
function cm.initial_effect(c)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_DISCARD)
    e1:SetProperty(0x14000)
    e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
    e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
        if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
            and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,3,nil) end
        Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_GRAVE)
        Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
    end)
    e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,3,3,nil)
        Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
        local g=Duel.GetOperatedGroup()
        if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
        local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
        if ct==3 then
            Duel.BreakEffect()
            if Duel.Draw(tp,2,REASON_EFFECT)>1 then
                Duel.ShuffleHand(p)
                Duel.BreakEffect()
                Duel.DiscardHand(p,nil,2,2,REASON_EFFECT+REASON_DISCARD)
            end
        end
    end)
    c:RegisterEffect(e1)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,1)
    e1:SetCategory(CATEGORY_DECKDES)
    e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
        return not Duel.CheckEvent(EVENT_CHAINING)
    end)
    local function spell_filter(c,mc,sec,e,tp,eg,ep,ev,re,r,rp)
        if not c:IsType(TYPE_SPELL) or not c:IsAbleToGrave() then return false end
        local te=c:GetActivateEffect()
        if not te then return false end
        if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
            return false
        end
        local code=te:GetCode()
		if (not sec or code~=EVENT_CHAINING) and code~=EVENT_FREE_CHAIN then
			return false
        end
        local con=te:GetCondition()
        local tg=te:GetTarget()
        local templ=e:GetLabel()
        local tempp=e:GetProperty()
        local tempg=e:GetCategory()
        e:SetLabel(te:GetLabel())
        e:SetProperty(tempp|te:GetProperty())
        e:SetCategory(tempg|te:GetCategory())
        local res=false
        if not Senya.ProtectedRun(con,e,tp,eg,ep,ev,re,r,rp) then res=1 end
        if not Senya.ProtectedRun(tg,e,tp,eg,ep,ev,re,r,rp,0) then res=2 end
        if not Senya.ProtectedRun(tg,e,tp,eg,ep,ev,re,r,rp,0,mc) then res=3 end
        --Debug.Message(c:GetCode().."-"..(res or 0))
        e:SetProperty(tempp)
        e:SetCategory(tempg)
        e:SetLabel(templ)
        return not res
    end
    local function monster_filter(c,sec,e,tp,eg,ep,ev,re,r,rp)
        return Duel.IsExistingMatchingCard(spell_filter,tp,LOCATION_DECK,0,1,nil,c,sec,e,tp,eg,ep,ev,re,r,rp)
    end
    e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
        if chkc then return false end
        local sec=(e:GetCode()==EVENT_CHAINING)
        if chk==0 then return Duel.IsExistingTarget(monster_filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,sec,e,tp,eg,ep,ev,re,r,rp) end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
        Duel.SelectTarget(tp,monster_filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,sec,e,tp,eg,ep,ev,re,r,rp)
    end)
    e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
        local tc=Duel.GetFirstTarget()
        local sec=(e:GetCode()==EVENT_CHAINING)
        if tc:IsRelateToEffect(e) then
            local g=Duel.SelectMatchingCard(tp,spell_filter,tp,LOCATION_DECK,0,1,1,nil,tc,sec,e,tp,eg,ep,ev,re,r,rp)
            local sc=g:GetFirst()
            if sc and Duel.SendtoGrave(sc,REASON_EFFECT)>0 then
                local te=sc:GetActivateEffect()
                local templ=e:GetLabel()
                local tempp=e:GetProperty()
                local tempg=e:GetCategory()
                e:SetLabel(te:GetLabel())
                e:SetProperty(tempp|te:GetProperty())
                e:SetCategory(tempg|te:GetCategory())
                local temp=Duel.GetFirstTarget
                Duel.GetFirstTarget=function()
                    return tc
                end
                Senya.ProtectedRun(te:GetOperation(),e,tp,eg,ep,ev,re,r,rp)
                Duel.GetFirstTarget=temp
                e:SetProperty(tempp)
                e:SetCategory(tempg)
                e:SetLabel(templ)
            end
        end
    end)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(aux.TRUE)
	c:RegisterEffect(e2)
end
