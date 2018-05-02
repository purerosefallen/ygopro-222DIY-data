--眯眯眼
function c5012618.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DRAW)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCondition(c5012618.cond)
	e0:SetTarget(c5012618.drtarg)
	e0:SetOperation(c5012618.drop)
	c:RegisterEffect(e0)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c5012618.tg)
	e1:SetOperation(c5012618.op)
	c:RegisterEffect(e1)
	--return to grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(5012618,0))
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetTarget(c5012618.retg)
	e4:SetOperation(c5012618.reop)
	c:RegisterEffect(e4)
	--cannot remove 
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(5012618,1))
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_REMOVE)
	e5:SetOperation(c5012618.acop)
	c:RegisterEffect(e5)
end
function c5012618.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x250) and (c:IsRankAbove(1) or c:IsLevelAbove(1))
end
function c5012618.sgfilter(c)
	return c:IsSetCard(0x250) and c:IsAbleToGrave() 
end
function c5012618.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c5012618.filter(chkc)  end
	if chk==0 then return   Duel.IsExistingTarget(c5012618.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c5012618.sgfilter,tp,LOCATION_EXTRA,0,1,nil)   end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c5012618.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c5012618.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	local lv=nil
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
	if tc:GetLevel()>0 then
	lv=tc:GetLevel()
	else
	lv=tc:GetRank()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LSCALE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(lv)
	e:GetHandler():RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	e:GetHandler():RegisterEffect(e2)
	local g=Duel.SelectMatchingCard(tp,c5012618.sgfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c5012618.cfilter(c)
	return c:IsSetCard(0x250) and c:IsType(TYPE_MONSTER) and c:GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c5012618.refilter(c)
	return c:IsFaceup() and c:IsSetCard(0x250) 
end
function c5012618.cond(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c5012618.cfilter,1,nil)
end
function c5012618.drtarg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c5012618.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c5012618.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5012618.refilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) 
	and Duel.IsExistingMatchingCard(nil,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
end
function c5012618.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.GetMatchingGroupCount(c5012618.refilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local sg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,g,nil)
	if sg:GetCount()>0 then
	Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
	end
end
function c5012618.acop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end