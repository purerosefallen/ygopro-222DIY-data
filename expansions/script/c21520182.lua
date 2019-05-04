--幻形魔-昂千德
function c21520182.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	aux.AddFusionProcMixRep(c,false,false,aux.FilterBoolFunction(Card.IsFusionSetCard,0x490),3,100)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c21520182.splimit)
	c:RegisterEffect(e1)
	--cost
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e00:SetDescription(aux.Stringid(21520182,4))
	e00:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e00:SetCode(EVENT_PHASE+PHASE_END)
	e00:SetCountLimit(1)
	e00:SetRange(LOCATION_MZONE)
	e00:SetCondition(c21520182.ccon)
	e00:SetOperation(c21520182.ccost)
	c:RegisterEffect(e00)
	--attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e2)
	
	--atk def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c21520182.matcheck)
	c:RegisterEffect(e4)
--[[	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c21520182.regcon)
	e5:SetOperation(c21520182.regop)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)--]]
	--copy
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetDescription(aux.Stringid(21520182,3))
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,21520182)
	e6:SetTarget(c21520182.cptg)
	e6:SetOperation(c21520182.cpop)
	c:RegisterEffect(e6)
	--draw
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_DRAW)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCondition(c21520182.drcon)
	e7:SetTarget(c21520182.drtg)
	e7:SetOperation(c21520182.drop)
	c:RegisterEffect(e7)
end
function c21520182.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c21520182.cfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_LIGHT) and not c:IsPublic()
end
function c21520182.ccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c21520182.ccost(e,tp)
	if tp~=Duel.GetTurnPlayer() then return end
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c21520182.cfilter1,tp,LOCATION_HAND,0,nil)
	local opselect=2
	if g1:GetCount()>0 then
		opselect=Duel.SelectOption(tp,aux.Stringid(21520182,0),aux.Stringid(21520182,1),aux.Stringid(21520182,2))
	else 
		opselect=Duel.SelectOption(tp,aux.Stringid(21520182,1),aux.Stringid(21520182,2))
		opselect=opselect+1
	end
	if opselect==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=g1:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	elseif opselect==1 then
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_ATKCHANGE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(-c:GetAttack())
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCategory(CATEGORY_DEFCHANGE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(-c:GetDefense())
		c:RegisterEffect(e2)
	else
		Duel.Destroy(e:GetHandler(),REASON_RULE)
	end
end
--[[
function c21520182.ffilter(c,cat,fc,race)
	if cat~=nil and race==nil then
		return c:IsFusionSetCard(0x490) and c:IsCanBeFusionMaterial(fc)
	elseif cat==nil and race~=nil then
		return c:IsRace(RACE_FIEND) and c:IsCanBeFusionMaterial(fc)
	end
end
function c21520182.fscondition(e,g,gc,chkf)
	if g==nil then return true end
	if gc then return false end
	local g1=g:Filter(c21520182.ffilter,nil,0x490,e:GetHandler(),nil)
	local c1=g1:GetCount()
	local g2=g:Filter(c21520182.ffilter,nil,nil,e:GetHandler(),RACE_FIEND)
	local c2=g2:GetCount()
	local ag=g1:Clone()
	ag:Merge(g2)
	if chkf~=PLAYER_NONE and not ag:IsExists(aux.FConditionCheckF,1,nil,chkf) then return false end
	return c1>0 and c2>1 and ag:GetCount()>=3
end
function c21520182.fsoperation(e,tp,eg,ep,ev,re,r,rp,gc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g1=g:Filter(c21520182.ffilter,nil,0x490,e:GetHandler(),nil)
	local g2=g:Filter(c21520182.ffilter,nil,nil,e:GetHandler(),RACE_FIEND)
	local ag=g1:Clone()
	ag:Merge(g2)
	local tc=nil
	local f1=0
	local f2=0
	local mg=Group.CreateGroup()
	Duel.SetFusionMaterial(eg:FilterSelect(tp,c21520182.ffilter,3,100,nil))
end
]]
function c21520182.matcheck(e,c)
--	local g=c:GetMaterial()
--	e:SetLabel(g:GetClassCount(Card.GetOriginalCode))
	local ct=c:GetMaterialCount()
	local ae=Effect.CreateEffect(c)
	ae:SetType(EFFECT_TYPE_SINGLE)
	ae:SetCode(EFFECT_SET_BASE_ATTACK)
	ae:SetValue(ct*450)
	ae:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(ae)
	local de=ae:Clone()
	de:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(de)
end
function c21520182.regcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c21520182.regop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	local c=e:GetHandler()
	local ae=Effect.CreateEffect(c)
	ae:SetType(EFFECT_TYPE_SINGLE)
	ae:SetCode(EFFECT_UPDATE_ATTACK)
	ae:SetValue(ct*900)
	ae:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(ae)
	local de=ae:Clone()
	de:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(de)
end
function c21520182.cpfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function c21520182.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c21520182.cpfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21520182.cpfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c21520182.cpfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,1,1,e:GetHandler())
--	local loc=g1:GetFirst():GetLocation()
--	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,1,tp,loc)
end
function c21520182.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsOnField() or c:IsFacedown() then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
--[[		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)--]]
		local code=tc:GetOriginalCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
--		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c21520182.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY)
end
function c21520182.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c21520182.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_REMOVED,LOCATION_REMOVED)
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	Duel.BreakEffect()
	local tg=Duel.GetOperatedGroup()
--	if tg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then 
		Duel.ShuffleDeck(tp) 
		Duel.ShuffleDeck(1-tp) 
--	end
	local ct=tg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then 
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end
