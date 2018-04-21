--瓦尔哈拉的薇尔丹蒂
function c22230161.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(c22230161.mfilter),1)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(22230161)
	--Link Arrow
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22230161,8))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c22230161.tg)
	e1:SetOperation(c22230161.op)
	c:RegisterEffect(e1)
end
c22230161.named_with_Valhalla=1
function c22230161.IsValhalla(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Valhalla
end
function c22230161.mfilter(c,lc)
	return c:GetBaseAttack()==0 or c22230161.IsValhalla(c)
end
function c22230161.cfilter(c)
	return c:IsType(TYPE_LINK) and c:GetLink()==1
end
function c22230161.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22230161.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22230161.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c22230161.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local rg=g:GetFirst():GetLinkedGroup()
	local b1=true
	local b2=rg:GetCount()>0 and Duel.IsPlayerCanDraw(tp,1)
	if chk==0 then return b1 or b2 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(22230161,9)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(22230161,10)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==2 then
		e:SetCategory(CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,rg:GetCount(),0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function c22230161.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local sel=e:GetLabel()
	if sel==1 then
		local op=Duel.SelectOption(tp,aux.Stringid(22230161,0),aux.Stringid(22230161,1),aux.Stringid(22230161,2),aux.Stringid(22230161,3),aux.Stringid(22230161,4),aux.Stringid(22230161,5),aux.Stringid(22230161,6),aux.Stringid(22230161,7))
		local lm=0
		if op==0 then lm=LINK_MARKER_TOP_LEFT 
		elseif op==1 then lm=LINK_MARKER_TOP 
		elseif op==2 then lm=LINK_MARKER_TOP_RIGHT 
		elseif op==3 then lm=LINK_MARKER_RIGHT 
		elseif op==4 then lm=LINK_MARKER_BOTTOM_RIGHT 
		elseif op==5 then lm=LINK_MARKER_BOTTOM 
		elseif op==6 then lm=LINK_MARKER_BOTTOM_LEFT 
		elseif op==7 then lm=LINK_MARKER_LEFT 
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_CHANGE_LINK_MARKER_KOISHI)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(lm)
		tc:RegisterEffect(e1)
	elseif sel==2 then
		local g=tc:GetLinkedGroup()
		if g:GetCount()>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end